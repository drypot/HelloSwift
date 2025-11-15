//
//  MessageClient.swift
//  HelloSwift
//
//  Created by Kyuhyun Park on 12/13/24.
//

import Foundation
import Network
import os

nonisolated public final class MessageClient: Sendable {
    private let id: Int
    private let connection: NWConnection
    private let packetQueue = NetworkPacketQueue()

    public init(host: String, port: UInt16) {
        self.id = connectionIDGen.next()!
        let nwHost = NWEndpoint.Host(host)
        let nwPort = NWEndpoint.Port(rawValue: port)!
        self.connection = NWConnection(host: nwHost, port: nwPort, using: .tcp)
    }

    func log(_ message: String) {
        print("client, \(id): \(message)")
    }

    public func start() {
        connection.stateUpdateHandler = { state in
            self.log("state, \(state)")

            switch state {
            case .failed(let error):
                self.log("error, \(error)")
                Task {
                    await self.packetQueue.enqueue(.error(error: error))
                }
                self.connection.cancel()

            case .cancelled:
                Task {
                    await self.packetQueue.enqueue(.completed)
                }

            default:
                break
            }
        }
        setupReceiver()
        connection.start(queue: .global())
    }

    public func stop() {
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
                Task {
                    await self.packetQueue.enqueue(.data(data: data))
                    if isComplete {
                        Task {
                            await self.packetQueue.enqueue(.completed)
                        }
                    } else {
                        self.setupHeaderReceiver()
                    }
                }
            }
        }
    }

    private func processReceiveError(_ error: NWError) {
        log("receive error, \(error)")
        self.stop()
        Task {
            await self.packetQueue.enqueue(.error(error: error))
        }
    }

    public func nextPacket() async -> NetworkPacket {
        return await packetQueue.dequeue()
    }

    public func send(_ data: Data) {
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

