//
//  SimpleHTTPResponseTests.swift
//  HelloSwiftTests
//
//  Created by Kyuhyun Park on 12/15/24.
//

import Foundation
import HelloSwift
import Testing

struct SimpleHTTPResponseTests {

    @Test func test() throws {
        let response = SimpleHTTPResponse()

        response.headers = [
            "Content-Type: text/plain"
        ]
        response.bodyString = "hello"

        let expected = """
            HTTP/1.1 200 OK\r
            Content-Type: text/plain\r
            Content-Length: 5\r
            \r
            hello
            """

        #expect(response.responseString() == expected)
    }

}
