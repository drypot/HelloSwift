//
//  IntSequenceWithLockTests.swift
//  HelloSwiftTests
//
//  Created by Kyuhyun Park on 11/19/24.
//

import Foundation
import Testing
import MyLibrary

struct IntSequenceWithLockTests {

    @Test func testIterator() throws {
        let i = IntSequenceWithLock(start: 10).makeIterator()

        #expect(i.next() == 10)
        #expect(i.next() == 11)
        #expect(i.next() == 12)
    }

    @Test func testIteratorClone() throws {
        let i = IntSequenceWithLock(start: 10).makeIterator()
        let j = i

        #expect(i.next() == 10)
        #expect(i.next() == 11)
        #expect(i.next() == 12)

        #expect(j.next() == 13)
        #expect(j.next() == 14)
        #expect(j.next() == 15)
    }

    @Test func testForIn() throws {
        let logger = SimpleLogger<Int>()

        for i in IntSequenceWithLock(start: 10) {
            logger.log(i)
            if i >= 15 { break }
        }

        #expect(logger.result() == [10, 11, 12, 13, 14, 15])
    }

}
