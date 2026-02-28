//
//  SequenceTransformingTests.swift
//  HelloSwiftTests
//
//  Created by Kyuhyun Park on 11/5/24.
//

import Foundation
import Testing

struct SequenceTransformingTests {

    @Test func testMap() throws {
        let cast = ["Vivien", "Marlon", "Kim", "Karl"]

        let lowercaseNames = cast.map { $0.lowercased() }
        #expect(lowercaseNames == ["vivien", "marlon", "kim", "karl"])

        let letterCounts = cast.map { $0.count }
        #expect(letterCounts == [6, 6, 3, 4])
    }

    @Test func testCompactMap() throws {
        let possibleNumbers = ["1", "2", "three", "///4///", "5"]

        let mapped: [Int?] = possibleNumbers.map { str in Int(str) }
        #expect(mapped == [1, 2, nil, nil, 5])

        let compactMapped: [Int] = possibleNumbers.compactMap { str in Int(str) }
        #expect(compactMapped == [1, 2, 5])
    }

    @Test func testFlatMap() throws {
        let numbers = [1, 2, 3, 4]

        let mapped = numbers.map { Array(repeating: $0, count: $0) }
        #expect(mapped == [[1], [2, 2], [3, 3, 3], [4, 4, 4, 4]])

        let flatMapped = numbers.flatMap { Array(repeating: $0, count: $0) }
        #expect(flatMapped == [1, 2, 2, 3, 3, 3, 4, 4, 4, 4])
    }

    @Test func testReduce() throws {
        let numbers = [1, 2, 3, 4]
        let sum = numbers.reduce(0, { sum, n in sum + n })
        #expect(sum == 10)
    }

    @Test func testReduceInto() throws {
        let letters = "abracadabra"
        let letterCount = letters.reduce(into: [:]) { counts, letter in
            counts[letter, default: 0] += 1
        }
        #expect(letterCount == ["a": 5, "b": 2, "r": 2, "c": 1, "d": 1])
    }

}
