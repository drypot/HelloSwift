//
//  SequenceSortingTests.swift
//  HelloSwiftTests
//
//  Created by Kyuhyun Park on 11/6/24.
//

import Foundation
import Testing

struct SequenceSortingTests {

    @Test func testSorted() throws {
        let students: Set = ["Kofi", "Abena", "Peter", "Kweku", "Akosua"]
        let sortedStudents = students.sorted()
        #expect(sortedStudents == ["Abena", "Akosua", "Kofi", "Kweku", "Peter"])
    }

    @Test func testSortedDescendingOrder() throws {
        let students: Set = ["Kofi", "Abena", "Peter", "Kweku", "Akosua"]
        let sortedStudents = students.sorted(by: >)
        #expect(sortedStudents == ["Peter", "Kweku", "Kofi", "Akosua", "Abena"])
    }

    @Test func testSortedBy() throws {

        enum HTTPResponse: Equatable {
            case ok
            case error(Int)
        }

        let responses: [HTTPResponse] = [.error(500), .ok, .ok, .error(404), .error(403)]

        let sortedResponses = responses.sorted {
            switch ($0, $1) {
            // Order errors by code
            case let (.error(aCode), .error(bCode)):
                return aCode < bCode

            // All successes are equivalent, so none is before any other
            case (.ok, .ok): return false

            // Order errors before successes
            case (.error, .ok): return true
            case (.ok, .error): return false
            }
        }

        #expect(sortedResponses == [.error(403), .error(404), .error(500), .ok, .ok])
    }

    @Test func testReversed() throws {
        let range = 0...5
        let reversedRange = range.reversed()
        #expect(reversedRange.elementsEqual([5, 4, 3, 2, 1, 0]))
    }

}
