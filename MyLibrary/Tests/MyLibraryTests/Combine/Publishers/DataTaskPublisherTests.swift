//
//  DataTaskPublisherTests.swift
//  HelloSwiftTests
//
//  Created by Kyuhyun Park on 12/15/24.
//

import Foundation
import Combine
import MyLibrary
import Testing

struct DataTaskPublisherTests {

    final class Router: SimpleHTTPRouter {
        func route(request: SimpleHTTPRequest, response: SimpleHTTPResponse) {
            response.headers = [
                "Content-Type: application/json; charset=utf-8"
            ]

            switch request.path {
            case "/echo":
                response.body = request.body
            case "/json1":
                response.bodyString = """
                    { "isAvailable": false, "userName": "sjobs" }
                    """
            default:
                response.bodyString = "invalid page"
            }
        }
    }

    struct UserNameAvailableMessage: Codable {
        var isAvailable: Bool
        var userName: String
    }

    @Test func testGet() async throws {
        let server = SimpleHTTPServer(port: 0, router: Router())
        try await server.start()
        let port = server.port!

        let url = URL(string: "http://localhost:\(port)/json1")!
        var iterator = URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: UserNameAvailableMessage.self, decoder: JSONDecoder())
            .map(\.userName)
            .values
            .makeAsyncIterator()

        let result = try await iterator.next()

        #expect(result == "sjobs")

        server.stop()
    }

}
