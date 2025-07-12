//
//  StrideTests.swift
//  HelloSwiftTests
//
//  Created by Kyuhyun Park on 11/2/24.
//

import Foundation
import Testing

struct StrideTests {

    @Test func testStrideable() throws {
        // Int confirms to Strideable protocol

        let value = 10

        #expect(value.advanced(by: 10) == 20)
        #expect(value.distance(to: 100) == 90)
    }

    @Test func testStrideTo() throws {
        // struct StrideTo<Element> where Element : Strideable
        // StrideTo confirms to Sequence

        let seq: StrideTo<Int> = stride(from: 0, to: 5, by: 1)
        var result = [Int]()

        for i in seq {
            result.append(i)
        }

        #expect(result == [0, 1, 2, 3, 4])
    }

    @Test func testStrideThrough() throws {
        // struct StrideThrough<Element> where Element : Strideable
        // StrideThrough confirms to Sequence

        let seq: StrideThrough<Int> = stride(from: 0, through: 5, by: 1)
        var result = [Int]()

        for i in seq {
            result.append(i)
        }

        #expect(result == [0, 1, 2, 3, 4, 5])
    }
}
