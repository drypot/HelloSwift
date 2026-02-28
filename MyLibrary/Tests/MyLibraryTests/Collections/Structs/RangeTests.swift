//
//  RangeTests.swift
//  HelloSwiftTests
//
//  Created by Kyuhyun Park on 11/1/24.
//

import Foundation
import Testing

struct RangeTests {

    @Test func testRange() throws {
        let underFive: Range<Double> = 0.0..<5.0

        #expect(underFive.contains(3.14) == true)
        #expect(underFive.contains(6.28) == false)
        #expect(underFive.contains(5.0) == false)

        #expect(underFive.lowerBound == 0.0)
        #expect(underFive.upperBound == 5.0)
    }

    @Test func testClosedRange() throws {
        let throughFive: ClosedRange<Double> = 0.0...5.0

        #expect(throughFive.contains(3.14) == true)
        #expect(throughFive.contains(6.28) == false)
        #expect(throughFive.contains(5.0) == true)

        #expect(Range(0...5) == 0..<6)
    }

    @Test func testPartialRangeUpTo() throws {
        let numbers = [0, 1, 2, 3, 4, 5, 6, 7]
        let range: PartialRangeUpTo<Int> = ..<3

        #expect(numbers[range] == [0, 1, 2])
    }

    @Test func testPartialRangeThrough() throws {
        let numbers = [0, 1, 2, 3, 4, 5, 6, 7]
        let range: PartialRangeThrough<Int> = ...3

        #expect(numbers[range] == [0, 1, 2, 3])
    }

    @Test func testPartialRangeFrom() throws {
        let numbers = [0, 1, 2, 3, 4, 5, 6, 7]
        let range: PartialRangeFrom<Int> = 3...

        #expect(numbers[range] == [3, 4, 5, 6, 7])
    }

    @Test func testForLoop() throws {
        var result = [Int]()

        for i in 0..<5 {
            result.append(i)
        }

        #expect(result == [0, 1, 2, 3, 4])
    }

    @Test func testForLoopClosedRange() throws {
        var result = [Int]()

        for i in 0...5 {
            result.append(i)
        }

        #expect(result == [0, 1, 2, 3, 4, 5])
    }

    @Test func testIsEmpty() throws {
        let empty = 0.0..<0.0

        #expect(empty.contains(0.0) == false)
        #expect(empty.isEmpty == true)
    }

}
