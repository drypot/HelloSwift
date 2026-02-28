//
//  SequenceSplittingTests.swift
//  HelloSwiftTests
//
//  Created by Kyuhyun Park on 11/6/24.
//

import Foundation
import Testing

// https://developer.apple.com/documentation/swift/sequence/split(separator:maxsplits:omittingemptysubsequences:)

struct SequenceSplittingTests {

    @Test func testSplit() throws {
        let line = "BLANCHE:   I don't want realism. I want magic!"
        let splited = line.split(
            separator: " ",
            maxSplits: .max,
            omittingEmptySubsequences: true
        )
        //let stringed = splited.map(String.init)

        #expect(
            splited ==
            ["BLANCHE:", "I", "don\'t", "want", "realism.", "I", "want", "magic!"]
        )
    }

    @Test func testSplitWithMaxSplits() throws {
        let line = "BLANCHE:   I don't want realism. I want magic!"
        let splited = line.split(separator: " ", maxSplits: 1)
        //let stringed = splited.map(String.init)

        #expect(
            splited ==
            ["BLANCHE:", "  I don\'t want realism. I want magic!"]
        )
    }

    @Test func testSplitWithOmittingEmptySubsequences() throws {
        let line = "BLANCHE:   I don't want realism. I want magic!"
        let splited = line.split(separator: " ", omittingEmptySubsequences: false)
        //let stringed = splited.map(String.init)

        #expect(
            splited ==
            ["BLANCHE:", "", "", "I", "don\'t", "want", "realism.", "I", "want", "magic!"]
        )
    }

    @Test func testSplitWhere() throws {
        let line = "BLANCHE:   I don't want realism. I want magic!"
        let splited = line.split { $0 == " " }
        //let stringed = splited.map(String.init)

        #expect(
            splited ==
            ["BLANCHE:", "I", "don\'t", "want", "realism.", "I", "want", "magic!"]
        )
    }

    @Test func testSplitWhereWithMaxSplits() throws {
        let line = "BLANCHE:   I don't want realism. I want magic!"
        let splited = line.split(maxSplits: 1) { $0 == " " }
            //.map(String.init)

        #expect(
            splited ==
            ["BLANCHE:", "  I don\'t want realism. I want magic!"]
        )
    }

    @Test func testJoined() throws {
        let ranges = [0..<3, 8..<10, 15..<17]
        let joined = ranges.joined()
        let array = Array(joined)

        #expect(array == [0, 1, 2, 8, 9, 15, 16])
    }

    @Test func testJoinedWithSeparator() throws {
        let nestedNumbers = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
        let joined = nestedNumbers.joined(separator: [-1, -2])
        let array = Array(joined)

        #expect(array == [1, 2, 3, -1, -2, 4, 5, 6, -1, -2, 7, 8, 9])
    }

    @Test func testJoinedWithString() throws {
        let cast = ["Vivien", "Marlon", "Kim", "Karl"]
        let list = cast.joined(separator: ", ")

        #expect(list == "Vivien, Marlon, Kim, Karl")
    }

}
