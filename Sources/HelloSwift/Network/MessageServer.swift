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

public final class MessageServer: Sendable {

    private let listener: NWListener

    public init(port: UInt16) {
        let nwPort = NWEndpoint.Port(rawValue: port)!
        self.listener = try! NWListener(using: .tcp, on: nwPort)
    }

    nonisolated func log(_ message: String) {
        print("server: \(message)")
    }

    public func start() async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            // handler 클로져들에 [weak self] 넣어야 하는데 넣지않고,
            // 대신 stop 메서드에서 stateUpdateHandler 에 nil 대입을 하고 있다.
            listener.stateUpdateHandler = { state in
                switch state {
                case .ready:
                    self.log("state, ready on port \(self.listener.port!)")
                    continuation.resume(returning: ())
                case .failed(let error):
                    self.log("state, failed, error: \(error)")
                    continuation.resume(throwing: error)
                case .cancelled:
                    self.log("state, canceled")
                    continuation.resume(throwing: NWError.posix(.ECANCELED))
                default:
                    self.log("state, \(state)")
                    break
                }
            }
            listener.newConnectionHandler = { connection in
                MessageServerConnection(connection: connection).start()
            }
            listener.start(queue: .global())
            log("started")
        }
    }

    public func stop() {
        self.listener.stateUpdateHandler = nil
        self.listener.newConnectionHandler = nil
        self.listener.cancel()
        log("stopped")
    }
}

nonisolated final class MessageServerConnection: @unchecked Sendable {
    private let id: Int
    private let connection: NWConnection
    private var receiveBuffer = Data()
    private var nextMessageLength: UInt32?

    init(connection: NWConnection) {
        self.id = connectionIDGen.next()!
        self.connection = connection
    }

    func log(_ message: String) {
        print("server connection \(self.id): \(message)")
    }

    func start() {
        connection.stateUpdateHandler = { state in
            switch state {
            case .waiting(let error):
                self.log("state, waiting, \(error)")
                self.stop()
            case .ready:
                self.log("state, ready")
            case .failed(let error):
                self.log("state, failed, \(error)")
                self.stop()
            default:
                self.log("state, \(state)")
                break
            }
        }
        setupReceiver()
        connection.start(queue: .global())
        log("started")
        send("hello")
    }

    func stop() {
        connection.stateUpdateHandler = nil
        connection.cancel()
        log("stopped")
    }

    private func setupReceiver() {
        connection.receive(
            minimumIncompleteLength: 1,
            maximumLength: connection.maximumDatagramSize
        ) { data, _, isComplete, error in

            if let data, !data.isEmpty {
                self.receiveBuffer.append(data)
                self.processBuffer()
            }
            if let error {
                self.log("receive error, \(error)")
                self.stop()
                return
            }
            if isComplete {
                self.log("completed")
                self.stop()
                return
            }
            self.setupReceiver()
        }
    }

    private func processBuffer() {
        while true {
            // Case 1: 아직 다음 메시지 길이를 모르는 상태 (헤더 읽기)
            if nextMessageLength == nil {
                let headerSize = MemoryLayout<UInt32>.size

                // 버퍼에 헤더를 읽을 만큼 데이터가 있는지 확인
                if receiveBuffer.count >= headerSize {
                    let lengthData = receiveBuffer.prefix(headerSize)
                    let length = lengthData.withUnsafeBytes { $0.load(as: UInt32.self).bigEndian }
                    receiveBuffer.removeFirst(headerSize)
                    nextMessageLength = length
                } else {
                    // 버퍼에 헤더도 채워지지 않았다면 다음 데이터 대기
                    break
                }
            }

            // Case 2: 다음 메시지 길이는 알고 있는 상태 (본문 읽기)
            if let requiredLength = nextMessageLength {
                let requiredIntLength = Int(requiredLength)
                if receiveBuffer.count >= requiredIntLength {
                    let payloadData = receiveBuffer.prefix(requiredIntLength)
                    receiveBuffer.removeFirst(requiredIntLength)
                    handleCompleteMessage(data: payloadData)
                    nextMessageLength = nil
                } else {
                    // 버퍼에 본문이 채워지지 않았다면 다음 데이터 대기
                    break
                }
            }
        }
    }

    private func handleCompleteMessage(data: Data) {
        if let message = String(data: data, encoding: .utf8) {
            send(message)
        } else {
            fatalError()
        }
    }

    func send(_ message: String) {
        let payload = message.data(using: .utf8)!
        let length = UInt32(payload.count)
        var bigEndianLength = length.bigEndian
        let lengthData = Data(bytes: &bigEndianLength, count: MemoryLayout<UInt32>.size)

        var framedMessage = Data()
        framedMessage.append(lengthData)
        framedMessage.append(payload)

        connection.send(content: framedMessage, completion: .contentProcessed({ error in
            if let error {
                self.log("send error, \(error)")
                self.stop()
            } else {
                self.log("sent, \(message)")
            }
        }))
    }

}

extension MessageServerConnection: Hashable {
    static func == (lhs: MessageServerConnection, rhs: MessageServerConnection) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
