//
//  SequenceSelectingElementsTest.swift
//  HelloSwiftTests
//
//  Created by Kyuhyun Park on 11/5/24.
//

import Foundation
import Testing

struct SequenceSelectingElementsTest {

    @Test func testPrefix() throws {
        let numbers = [1, 2, 3, 4, 5]
        #expect(numbers.prefix(2) == [1, 2])
        #expect(numbers.prefix(10) == [1, 2, 3, 4, 5])
    }

    @Test func testPrefixWhile() throws {
        let numbers = [3, 7, 4, -2, 9, -6, 10, 1]
        #expect(numbers.prefix { $0 > 0 } == [3, 7, 4])
    }

    @Test func testSuffix() throws {
        let numbers = [1, 2, 3, 4, 5]
        #expect(numbers.suffix(2) == [4, 5])
        #expect(numbers.suffix(10) == [1, 2, 3, 4, 5])
    }

}
