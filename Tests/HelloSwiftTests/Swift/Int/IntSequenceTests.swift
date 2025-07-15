//
//  IntSequenceTest.swift
//  HelloSwift
//
//  Created by Kyuhyun Park on 7/15/25.
//

import Foundation
import Testing
import HelloSwift

struct IntSequenceTests {

    @Test func test() throws {
        var i = IntSequence(start: 10)

        #expect(i.next() == 10)
        #expect(i.next() == 11)
        #expect(i.next() == 12)
    }

    @Test func test2() throws {
        let logger = SimpleLogger<Int>()

        for i in IntSequence(start: 10) {
            logger.log(i)
            if i >= 15 { break }
        }

        #expect(logger.result() == [10, 11, 12, 13, 14, 15])
    }

}
