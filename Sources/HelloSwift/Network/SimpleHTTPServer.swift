//
//  SimpleHTTPServer.swift
//  HelloSwift
//
//  Created by Kyuhyun Park on 12/9/24.
//

import Foundation
import Network

// https://github.com/httpswift/swifter
// https://ko9.org/posts/simple-swift-web-server/

public protocol SimpleHTTPRouter: Sendable {
    func route(request: SimpleHTTPRequest, response: SimpleHTTPResponse)
}

public final class SimpleHTTPServer<Router>: Sendable
    where Router: SimpleHTTPRouter {

    private let listener: NWListener
    private let router: Router

    public var port: UInt16? { listener.port?.rawValue }

    public init(port: UInt16, router: Router) {
        let nwPort = NWEndpoint.Port(rawValue: port)!
        self.listener = try! NWListener(using: .tcp, on: nwPort)
        self.router = router
    }

    func log(_ message: String) {
        print("web server: \(message)")
    }

    public func start() async throws {
        await withCheckedContinuation { continuation in
            listener.stateUpdateHandler = { state in
                switch state {
                case .ready:
                    self.log("state, ready on port \(self.listener.port!)")
                    continuation.resume()
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
                SimpleHTTPServerConnection(connection: connection, router: self.router).start()
            }
            listener.start(queue: .global())
        }
        log("started")
    }

    public func stop() {
        self.listener.stateUpdateHandler = nil
        self.listener.newConnectionHandler = nil
        self.listener.cancel()
        log("stopped")
    }

}

final class SimpleHTTPServerConnection<Router>: Sendable
    where Router: SimpleHTTPRouter {

    let id: Int
    let connection: NWConnection
    let router: Router
    nonisolated(unsafe) var request: SimpleHTTPRequest?

    init(connection: NWConnection, router: Router) {
        self.id = connectionIDGen.next()!
        self.connection = connection
        self.router = router
    }

    func log(_ message: String) {
        print("web connection \(self.id): \(message)")
    }

    func start() {
        receive()
        connection.start(queue: .global())
        log("started")
    }

    private func receive() {
        connection.receive(
            minimumIncompleteLength: 1,
            maximumLength: connection.maximumDatagramSize
        ) { data, _, isComplete, error in

            if let error {
                self.log("receive error, \(error)")
                self.stop()
                return
            }
            if let data {
                self.log("data arrived: \(data.count)")

                if self.request == nil {
                    self.request = SimpleHTTPRequest.parse(data)
                } else {
                    self.request!.appendToBody(data)
                }
                guard let request = self.request else { fatalError() }
                var length = 0
                if let contentLength = request.headers["Content-Length"] {
                    length = Int(contentLength)!
                }
                if request.body.count >= length {
                    self.log("request arrived, \(request.path)")
                    let response = SimpleHTTPResponse()
                    self.router.route(request: request, response: response)
                    self.connection.send(content: response.responseData(), completion: .idempotent)
                    self.request = nil
                }
            }
            if isComplete {
                self.log("completed")
            } else {
                self.log("receive again")
                self.receive()
            }
        }
    }

    func stop() {
        connection.stateUpdateHandler = nil
        connection.cancel()
        log("stopped")
    }

}

extension SimpleHTTPServerConnection: Hashable {
    static func == (lhs: SimpleHTTPServerConnection, rhs: SimpleHTTPServerConnection) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
