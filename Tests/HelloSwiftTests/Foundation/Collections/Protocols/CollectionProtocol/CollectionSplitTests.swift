//
//  CollectionSplitTests.swift
//  HelloSwiftTests
//
//  Created by Kyuhyun Park on 11/10/24.
//

import Foundation
import Testing

// https://developer.apple.com/documentation/swift/collection/split(separator:maxsplits:omittingemptysubsequences:)-6c22

struct CollectionSplitTests {

    @Test func testSplit() throws {
        let numbers = [0, 1, 2, 0, 3, 4, 0, 5]
        let splits = numbers.split(
            separator: 0,
            maxSplits: Int.max,
            omittingEmptySubsequences: true
        )

        #expect(splits.count == 3)
        #expect(splits[0] == [1, 2])
        #expect(splits[1] == [3, 4])
        #expect(splits[2] == [5])
    }

    @Test func testSplitByCollection() throws {
        let numbers = [0, 1, 2, 0, 0, 3, 4, 0, 5]
        let splits = numbers.split(
            separator: [0, 0],
            maxSplits: Int.max,
            omittingEmptySubsequences: true
        )

        #expect(splits.count == 2)
        #expect(splits[0] == [0, 1, 2])
        #expect(splits[1] == [3, 4, 0, 5])
    }

    @Test func testSplitWhere() throws {
        let numbers = [0, 1, 2, 0, 3, 4, 0, 5]
        let splits = numbers.split(
            maxSplits: Int.max,
            omittingEmptySubsequences: true
        ) {
            $0 == 0
        }

        #expect(splits.count == 3)
        #expect(splits[0] == [1, 2])
        #expect(splits[1] == [3, 4])
        #expect(splits[2] == [5])
    }


}
