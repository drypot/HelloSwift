//
//  URLFormatTests.swift
//  HelloSwiftTests
//
//  Created by Kyuhyun Park on 3/18/25.
//

import Foundation
import Testing

// Data Formatting
// https://developer.apple.com/documentation/foundation/data_formatting

// URL.FormatStyle
// https://developer.apple.com/documentation/foundation/url/formatstyle

struct URLFormatTests {

    @Test func testFactory() throws {

        // https://developer.apple.com/documentation/foundation/formatstyle/4013379-url
        // url: A style for formatting a URL.

        let url = URL(string: "http://www.example.com:8080/path/to/file.txt")!

        let formatted = url.formatted(
            .url
            .scheme(.never)
            .host(.omitSpecificSubdomains(["www"]))
            .port(.never)
        )

        #expect(formatted == "example.com/path/to/file.txt")
    }

    @Test func testStyle() throws {
        let style = URL.FormatStyle(
            scheme: .always,
            user: .never,
            password: .never,
            host: .always,
            port: .always,
            path: .always,
            query: .never,
            fragment: .never
        )

        let url = URL(string:"https://www.example.com:8080/path/to/endpoint?key=value")!

        let formatted1 = style.format(url)
        let formatted2 = url.formatted(style)

        #expect(formatted1 == "https://www.example.com:8080/path/to/endpoint")
        #expect(formatted2 == "https://www.example.com:8080/path/to/endpoint")
    }

}
