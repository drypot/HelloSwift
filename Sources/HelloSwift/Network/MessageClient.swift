//
//  MessageClient.swift
//  HelloSwift
//
//  Created by Kyuhyun Park on 12/13/24.
//

import Foundation
import Network
import os

nonisolated public final class MessageClientConnection: @unchecked Sendable {
    private let id: Int
    private let connection: NWConnection
    private var receiveBuffer = Data()
    private var nextMessageLength: UInt32?
    private let messageBuffer = MessageQueue()

    public init(host: String, port: UInt16) {
        self.id = connectionIDGen.next()!
        let nwHost = NWEndpoint.Host(host)
        let nwPort = NWEndpoint.Port(rawValue: port)!
        self.connection = NWConnection(host: nwHost, port: nwPort, using: .tcp)
    }

    func log(_ message: String) {
        print("client connection \(id): \(message)")
    }

    public func start() async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            connection.stateUpdateHandler = { state in
                switch state {
                case .waiting(let error):
                    self.log("state, waiting, \(error)")
                    //self.stop()
                case .ready:
                    self.log("state, ready")
                    continuation.resume(returning: ())
                case .failed(let error):
                    self.log("state, failed, error: \(error)")
                    continuation.resume(throwing: error)
                default:
                    self.log("state, \(state)")
                    break
                }
            }
            setupReceiver()
            connection.start(queue: .global())
            log("started")
        }
    }

    public func stop() {
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
            Task {
                await messageBuffer.enqueue(message)
            }
        } else {
            fatalError()
        }
    }

    public func receive() async -> String {
        return await messageBuffer.dequeue()
    }

    public func send(_ message: String) async throws {
        let payload = message.data(using: .utf8)!
        let length = UInt32(payload.count)
        var lengthBigEndian = length.bigEndian
        let lengthData = withUnsafeBytes(of: lengthBigEndian) { Data($0) }

        var packet = Data()
        packet.append(lengthData)
        packet.append(payload)

        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            connection.send(content: packet, completion: .contentProcessed({ error in
                if let error {
                    self.log("send error, \(error)")
                    self.stop()
                    continuation.resume(throwing: error)
                } else {
                    self.log("sent, \(message)")
                    continuation.resume(returning: ())
                }
            }))
        }
    }

}

fileprivate actor MessageQueue {
    private var queue: [String] = []
    private var waiting: [CheckedContinuation<String, Never>] = []

    func enqueue(_ value: String) {
        if let waiter = waiting.first {
            waiting.removeFirst()
            waiter.resume(returning: value)
        } else {
            queue.append(value)
        }
    }

    func dequeue() async -> String {
        if !queue.isEmpty {
            return queue.removeFirst()
        }

        return await withCheckedContinuation { continuation in
            waiting.append(continuation)
        }
    }

}
