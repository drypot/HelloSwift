//
//  SimpleHTTPServerTests.swift
//  HelloSwiftTests
//
//  Created by Kyuhyun Park on 12/9/24.
//

import Foundation
import Testing
import HelloSwift

struct SimpleHTTPServerTests {

    final class Router: SimpleHTTPRouter {
        func route(request: SimpleHTTPRequest, response: SimpleHTTPResponse) {
            response.headers = [
                "Content-Type: text/plain"
            ]

            switch request.path {
            case "/echo":
                response.body = request.body
            case "/abc":
                response.bodyString = "abc"
            default:
                response.bodyString = "invalid page"
            }
        }
    }

    @Test func testGet() async throws {
        let server = SimpleHTTPServer(port: 0, router: Router())
        try await server.start()
        let port = server.port!

        do {
            let url = URL(string: "http://localhost:\(port)/abc")!
            let (data, _) = try await URLSession.shared.data(from: url)
            let content = String(data: data, encoding: .utf8)

            #expect(content! == "abc")
        }
        do {
            let url = URL(string: "http://localhost:\(port)/echo")!

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = "hello".data(using: .utf8)

            let (data, _) = try await URLSession.shared.data(for: request)
            let content = String(data: data, encoding: .utf8)

            #expect(content! == "hello")
        }

        server.stop()
    }

}
