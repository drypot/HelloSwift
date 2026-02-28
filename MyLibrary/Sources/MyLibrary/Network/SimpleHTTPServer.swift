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

public nonisolated protocol SimpleHTTPRouter: Sendable {
    func route(request: SimpleHTTPRequest, response: SimpleHTTPResponse)
}

nonisolated public final class SimpleHTTPServer<Router>: Sendable
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
                SimpleHTTPServerClientHandler(connection: connection, router: self.router).start()
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

nonisolated final class SimpleHTTPServerClientHandler<Router>: Sendable
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
        print("web server, \(self.id): \(message)")
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
    }

    private func setupReceiver() {
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
                if !isComplete {
                    self.setupReceiver()
                }
            }
        }
    }

    func stop() {
        connection.cancel()
    }

}

extension SimpleHTTPServerClientHandler: Hashable {
    static func == (lhs: SimpleHTTPServerClientHandler, rhs: SimpleHTTPServerClientHandler) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
