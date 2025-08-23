//
//  StringInterpolationTests.swift
//  HelloSwiftTests
//
//  Created by Kyuhyun Park on 10/27/24.
//

import Foundation
import Testing

// 커스텀 스트링을 만드는 Swift 1.0 방식

struct StringInterpolationTests {

    @Test func testStringInterpolation() throws {
        let name = "Alice"
        let age = 30
        let greeting = "\(name) is \(age) years old."

        #expect(greeting == "Alice is 30 years old.")
    }

    @Test func testCustomStringConvertible() throws {

        struct Product: CustomStringConvertible {
            let name: String
            let price: Double

            var description: String {
                return "\(name), \(price), Style 1"
            }
        }

        let product = Product(name: "Book", price: 12.99)
        #expect("\(product)" == "Book, 12.99, Style 1")
    }

}
