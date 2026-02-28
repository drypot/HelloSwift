//
//  MessageServer.swift
//  HelloSwift
//
//  Created by Kyuhyun Park on 12/13/24.
//

import Foundation
import Network
import os

// https://rderik.com/blog/building-a-server-client-aplication-using-apple-s-network-framework/

nonisolated let connectionIDGen = IntSequenceWithLockIterator()

public nonisolated final class MessageServer: Sendable {

    private let listener: NWListener

    public init(port: UInt16) {
        let nwPort = NWEndpoint.Port(rawValue: port)!
        self.listener = try! NWListener(using: .tcp, on: nwPort)
    }

    func log(_ message: String) {
        print("server: \(message)")
    }

    public func start() async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            listener.stateUpdateHandler = { state in
                self.log("state, \(state)")
                
                switch state {
                case .ready:
                    continuation.resume(returning: ())

                case .failed(let error):
                    self.log("error, \(error)")
                    continuation.resume(throwing: error)

                case .cancelled:
                    continuation.resume(throwing: NWError.posix(.ECANCELED))

                default:
                    break
                }
            }
            listener.newConnectionHandler = { connection in
                MessageServerClientHandler(connection: connection).start()
            }
            listener.start(queue: .global())
        }
        listener.stateUpdateHandler = { state in
            self.log("state, \(state)")

            switch state {
            case .failed(let error):
                self.log("error, \(error)")
                self.listener.cancel()

            case .cancelled:
                break

            default:
                break
            }
        }
    }

    public func stop() {
        self.listener.cancel()
    }

}

nonisolated final class MessageServerClientHandler: Sendable {
    private let id: Int
    private let connection: NWConnection

    init(connection: NWConnection) {
        self.id = connectionIDGen.next()!
        self.connection = connection
    }

    func log(_ message: String) {
        print("server, \(self.id): \(message)")
    }

    func start() {
        connection.stateUpdateHandler = { state in
            self.log("state, \(state)")

            switch state {
            case .failed(let error):
                self.log("error, \(error)")
                self.connection.cancel()

            case .cancelled:
                break

            default:
                break
            }
        }
        setupReceiver()
        connection.start(queue: .global())
        send("hello".data(using: .utf8)!)
    }

    func stop() {
        connection.cancel()
    }

    private func setupReceiver() {
        setupHeaderReceiver()
    }

    private func setupHeaderReceiver() {
        connection.receive(minimumIncompleteLength: 4, maximumLength: 4) { data, _, isComplete, error in
            if let error {
                self.processReceiveError(error)
                return
            }
            if let data, data.count == 4 {
                let lengthBE = data.withUnsafeBytes { $0.load(as: UInt32.self) }
                let length = Int(UInt32(bigEndian: lengthBE))
                self.log("received header")
                if !isComplete {
                    self.setupPayloadReceiver(length: length)
                }
            }
        }
    }

    private func setupPayloadReceiver(length: Int) {
        connection.receive(minimumIncompleteLength: length, maximumLength: length) { data, _, isComplete, error in
            if let error {
                self.processReceiveError(error)
                return
            }
            if let data, data.count == length {
                self.log("received data, length \(length)")
                self.process(data)
                if !isComplete {
                    self.setupHeaderReceiver()
                }
            }
        }
    }

    private func processReceiveError(_ error: NWError) {
        log("receive error, \(error)")
        stop()
    }

    private func process(_ data: Data) {
        send(data)
    }

    func send(_ data: Data) {
        let length = UInt32(data.count)
        let lengthBE = length.bigEndian
        let lengthData = withUnsafeBytes(of: lengthBE) { Data($0) }

        var packet = Data()
        packet.append(lengthData)
        packet.append(data)

        connection.send(content: packet, completion: .contentProcessed({ error in
            if let error {
                self.log("send error, \(error)")
            } else {
                self.log("sent, length \(length)")
            }
        }))
    }

}

extension MessageServerClientHandler: Hashable {
    static func == (lhs: MessageServerClientHandler, rhs: MessageServerClientHandler) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
