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

let connectionIDGen = IntIDGenerator()

public final class MessageServer: Sendable {

    private let listener: NWListener

    public init(port: UInt16) {
        let nwPort = NWEndpoint.Port(rawValue: port)!
        self.listener = try! NWListener(using: .tcp, on: nwPort)
    }

    func log(_ message: String) {
        print("server: \(message)")
    }

    public func start() throws {
        // handler 클로져들에 [weak self] 넣어야 하는데 넣지않고,
        // 대신 close 메서드에서 nil 대입을 하고 있다.
        listener.stateUpdateHandler = { state in
            switch state {
            case .ready:
                self.log("state, ready on port \(self.listener.port!)")
            case .failed(let error):
                self.log("state, failed, error: \(error)")
                // exit(EXIT_FAILURE)
            case .cancelled:
                self.log("state, canceled")
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

    public func stop() {
        self.listener.stateUpdateHandler = nil
        self.listener.newConnectionHandler = nil
        self.listener.cancel()
        log("stopped")
    }
}

final class MessageServerConnection: Sendable {

    let id: Int
    let connection: NWConnection

    init(connection: NWConnection) {
        self.id = connectionIDGen.nextID()
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
        setupReceiveHandler()
        connection.start(queue: .global())
        log("started")
        send("hello")
    }

    private func setupReceiveHandler() {
        connection.receive(
            minimumIncompleteLength: 1,
            maximumLength: connection.maximumDatagramSize
        ) { data, _, isComplete, error in

            if let data, let message = String(data: data, encoding: .utf8) {
                self.log("received, \(message)")
                self.send(message)
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
            self.setupReceiveHandler()
        }
    }

    func send(_ message: String) {
        let data = message.data(using: .utf8)!
        connection.send(content: data, completion: .contentProcessed( { error in
            if let error {
                self.log("send error, \(error)")
                self.stop()
                return
            }
            self.log("sent, \(message)")
        }))
    }

    func stop() {
        connection.stateUpdateHandler = nil
        connection.cancel()
        log("stopped")
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
