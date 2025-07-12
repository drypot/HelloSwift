//
//  SequenceIteratingTests.swift
//  HelloSwiftTests
//
//  Created by Kyuhyun Park on 11/1/24.
//

import Foundation
import Testing

struct SequenceIteratingTests {

    @Test func testForLoop() throws {
        let range = 0...2

        var result = [Int]()

        for number in range {
            result.append(number)
        }

        #expect(result == [0, 1, 2])
    }

    @Test func testForEach() throws {
        let range = 0...2

        var result = [Int]()

        // break, continue, return 등으로 루프를 중지할 수 없다.

        range.forEach { number in
            result.append(number)
        }

        #expect(result == [0, 1, 2])
    }

    @Test func testEnumerated() throws {
        var result = [String]()

        for (n, c) in "Swift".enumerated() {
            result.append("\(n): \(c)")
        }
        #expect(result == [
            "0: S",
            "1: w",
            "2: i",
            "3: f",
            "4: t",
        ])
    }

}
