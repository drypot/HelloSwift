//
//  SequenceShuffleTests.swift
//  HelloSwiftTests
//
//  Created by Kyuhyun Park on 11/6/24.
//

import Foundation
import Testing

struct SequenceShuffleTests {

    @Test func testShuffled() throws {
        let numbers = 0...9
        let shuffled = numbers.shuffled()

        #expect(shuffled.count == 10)
        #expect(shuffled.allSatisfy { numbers.contains($0) })
        #expect(Set(shuffled).count == 10)
    }

}
