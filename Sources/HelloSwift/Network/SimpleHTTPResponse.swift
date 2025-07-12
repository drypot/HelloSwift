//
//  SimpleHTTPResponse.swift
//  HelloSwift
//
//  Created by Kyuhyun Park on 12/15/24.
//

import Foundation

// https://ko9.org/posts/simple-swift-web-server/

public final class SimpleHTTPResponse {
    public var httpVersion: String
    public var status: Int
    public var reason: String
    public var headers: [String]
    public var body: Data?

    public var bodyString: String? {
        get {
            guard let body else { return nil }
            return String(data: body, encoding: .utf8)
        }
        set {
            body = newValue?.data(using: .utf8)
        }
    }

    public init(
        httpVersion: String = "HTTP/1.1",
        status: Int = 200,
        reason: String = "OK",
        headers: [String] = [],
        body: Data? = nil) {

        self.httpVersion = httpVersion
        self.status = status
        self.reason = reason
        self.headers = headers
        self.body = body
    }

    public func responseData() -> Data {
        let statusLine = "\(httpVersion) \(status) \(reason)"

        var lines = [statusLine]
        lines.append(contentsOf: headers)
        lines.append("Content-Length: \(body?.count ?? 0)")
        lines.append("")
        lines.append("")
        let headersData = lines.joined(separator: "\r\n").data(using: .utf8)!

        if let body {
            return headersData + body
        } else {
            return headersData
        }
    }

    public func responseString() -> String {
        return String(data: responseData(), encoding: .utf8)!
    }
}
