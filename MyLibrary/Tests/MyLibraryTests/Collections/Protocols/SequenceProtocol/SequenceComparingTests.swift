//
//  SequenceComparingTests.swift
//  HelloSwiftTests
//
//  Created by Kyuhyun Park on 11/7/24.
//

import Foundation
import Testing

struct SequenceComparingTests {

    @Test func testElementsEqual() throws {
        let a = 1...3
        let b = 1...10

        #expect(a.elementsEqual(b) == false)
        #expect(a.elementsEqual([1, 2, 3]) == true)
    }

    @Test func testElementsEqualBy() throws {
        let a = 1...3
        let b = 1...3
        let c = 3...5

        #expect(a.elementsEqual(b) { $0 == $1 - 2 } == false)
        #expect(a.elementsEqual(c) { $0 == $1 - 2 } == true)
    }

    @Test func testStarts() throws {
        let a = 1...3
        let b = 1...10
        let c = 2...10

        #expect(b.starts(with: a) == true)
        #expect(c.starts(with: a) == false)
    }

    @Test func testStartsBy() throws {
        let a = 1...3
        let b = 1...10
        let c = 3...10

        #expect(b.starts(with: a) { $0 == $1 + 2 } == false)
        #expect(c.starts(with: a) { $0 == $1 + 2 } == true)
    }

    @Test func testLexicographicallyPrecedes() throws {

        // 시퀀스의 크고 작음을 판단하는데 유니코드 처리는 안 하는,
        // 엘리먼트끼리 단순 < 수치 비교이다.

        let a = [1, 2, 2, 2]
        let b = [1, 2, 3, 4]

        #expect(a.lexicographicallyPrecedes(b) == true)
        #expect(b.lexicographicallyPrecedes(b) == false)
    }

    @Test func testLexicographicallyPrecedesBy() throws {

        let a = [1, 2, 2, 2]
        let b = [1, 2, 3, 4]

        #expect(a.lexicographicallyPrecedes(b) { $0 < $1 } == true)
        #expect(b.lexicographicallyPrecedes(b) { $0 < $1 } == false)
    }
}
