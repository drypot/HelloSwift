//
//  MessageClient.swift
//  HelloSwift
//
//  Created by Kyuhyun Park on 12/13/24.
//

import Foundation
import Network
import os

public final class MessageClient: Sendable {

    let id: Int
    let connection: NWConnection

    public init(host: String, port: UInt16) {
        self.id = connectionIDGen.nextID()
        let nwHost = NWEndpoint.Host(host)
        let nwPort = NWEndpoint.Port(rawValue: port)!
        self.connection = NWConnection(host: nwHost, port: nwPort, using: .tcp)
    }

    func log(_ message: String) {
        print("client connection \(id): \(message)")
    }

    public func start() {
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
        connection.start(queue: .global())
        log("started")
    }

    public func receive() async -> String {
        let (data, _, isComplete, error) = await withCheckedContinuation { continuation in
            connection.receive(minimumIncompleteLength: 1, maximumLength: connection.maximumDatagramSize ) {
                continuation.resume(returning: ($0, $1, $2, $3))
            }
        }
        var result = "empty data"
        if let data, !data.isEmpty {
            if let message = String(data: data, encoding: .utf8) {
                log("received, \(message)")
                result = message
            } else {
                result = "parsing error"
            }
        }
        if let error {
            self.log("receive error, \(error)")
            self.stop()
        }
        if isComplete {
            self.log("completed")
            self.stop()
        }
        return result
    }

    public func send(_ message: String) async {
        let data = message.data(using: .utf8)!
        let error = await withCheckedContinuation { continuation in
            connection.send(content: data, completion: .contentProcessed( { error in
                continuation.resume(returning: error)
            }))
        }
        if let error {
            log("send error, \(error)")
            stop()
            return
        }
        log("sent, \(message)")
    }

    public func stop() {
        connection.stateUpdateHandler = nil
        connection.cancel()
        log("stopped")
    }
}
