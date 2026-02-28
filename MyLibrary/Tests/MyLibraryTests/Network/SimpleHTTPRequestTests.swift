//
//  SimpleHTTPRequestTests.swift
//  HelloSwiftTests
//
//  Created by Kyuhyun Park on 12/14/24.
//

import Foundation
import Testing
import MyLibrary

struct SimpleHTTPRequestTests {

    @Test func testGet() throws {
        let requestData = """
            GET /data HTTP/1.1\r
            Host: localhost:8080\r
            Accept: */*\r
            Accept-Language: ko-KR,ko;q=0.9\r
            Connection: keep-alive\r
            \r\n
            """.data(using: .utf8)!

        guard let req = SimpleHTTPRequest.parse(requestData) else {
            fatalError()
        }

        print(req)
        #expect(req.method == "GET")
        #expect(req.path == "/data")
        #expect(req.httpVersion == "HTTP/1.1")
        #expect(req.headers.count == 4)
        #expect(req.headers["Host"] == "localhost:8080")
        #expect(req.body.count == 0)
    }

    @Test func testPost() throws {
        let requestData = """
            POST /echo HTTP/1.1\r
            Host: localhost:8080\r
            Accept: */*\r
            Accept-Language: ko-KR,ko;q=0.9\r
            Connection: keep-alive\r
            \r
            hello, world!
            """.data(using: .utf8)!

        guard let req = SimpleHTTPRequest.parse(requestData) else { fatalError() }

        #expect(req.method == "POST")
        #expect(req.path == "/echo")
        #expect(req.httpVersion == "HTTP/1.1")
        #expect(req.headers["Host"] == "localhost:8080")
        #expect(req.bodyString == "hello, world!")
    }

}
