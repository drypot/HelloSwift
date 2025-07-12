//
//  SimpleHTTPRequest.swift
//  HelloSwift
//
//  Created by Kyuhyun Park on 12/14/24.
//

import Foundation

// https://ko9.org/posts/simple-swift-web-server/

public final class SimpleHTTPRequest {
    public let method: String
    public let path: String
    public let httpVersion: String
    public let headers: [String: String]
    public var body: Data

    public var bodyString: String { String(data: body, encoding: .utf8)! }

    static let delimiter = "\r\n\r\n".data(using: .utf8)!

    init(method: String, path: String, httpVersion: String, headers: [String : String], body: Data) {
        self.method = method
        self.path = path
        self.httpVersion = httpVersion
        self.headers = headers
        self.body = body
    }

    public static func parse(_ data: Data) -> SimpleHTTPRequest? {
        guard let range = data.firstRange(of: delimiter) else { return nil }
        let headersData = data[0..<range.lowerBound]
        let body = data[range.upperBound...]

        let headersString = String(data: headersData, encoding: .utf8)!
        let lines = headersString.components(separatedBy: "\r\n")

        guard let firstLine = lines.first else { return nil }

        let firstLineParts = firstLine.components(separatedBy: " ")
        guard firstLineParts.count == 3 else { return nil }

        let method = firstLineParts[0]
        let path = firstLineParts[1].removingPercentEncoding!
        let httpVersion = firstLineParts[2]

        var headers = [String: String]()
        for line in lines[1...] {
            let parts = line.split(separator: ":", maxSplits: 1)
            if parts.count != 2 { continue }
            let key = String(parts[0])
            let value = parts[1].trimmingCharacters(in: .whitespaces)
            headers[key] = value
        }

        return SimpleHTTPRequest(
            method: method,
            path: path,
            httpVersion: httpVersion,
            headers: headers,
            body: body
        )
    }

    public func appendToBody(_ data: Data) {
        body.append(data)
    }

}
