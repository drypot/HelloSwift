//
//  SequenceExcludingElementsTests.swift
//  HelloSwiftTests
//
//  Created by Kyuhyun Park on 11/5/24.
//

import Foundation
import Testing

struct SequenceExcludingElementsTests {

    @Test func testDropFirst() throws {
        let numbers = [1, 2, 3, 4, 5]
        #expect(numbers.dropFirst(2) == [3, 4, 5])
        #expect(numbers.dropFirst(10) == [])
    }

    @Test func testDropLast() throws {
        let numbers = [1, 2, 3, 4, 5]
        #expect(numbers.dropLast(2) == [1, 2, 3])
        #expect(numbers.dropLast(10) == [])
    }

    @Test func testDropWhile() throws {
        let numbers = [3, 7, 4, -2, 9, -6, 10, 1]
        #expect(numbers.drop(while: { $0 > 0 }) == [-2, 9, -6, 10, 1])
    }

    @Test func testFilter() throws {
        let cast = ["Vivien", "Marlon", "Kim", "Karl"]
        #expect(cast.filter { $0.count < 5 } == ["Kim", "Karl"])
    }

}
