//
//  SequenceFindingElementsTests.swift
//  HelloSwiftTests
//
//  Created by Kyuhyun Park on 11/5/24.
//

import Foundation
import Testing

struct SequenceFindingElementsTests {

    @Test func testContains() throws {
        let cast = ["Vivien", "Marlon", "Kim", "Karl"]
        #expect(cast.contains("Marlon") == true)
        #expect(cast.contains("James") == false)
    }

    @Test func testContainsWhere() throws {
        let expenses = [21.37, 55.21, 9.32, 10.18, 388.77, 11.41]
        #expect(expenses.contains { $0 > 100 } == true)
        #expect(expenses.contains { $0 < 0 } == false)
    }

    @Test func testAllSatisfy() throws {
        let names = ["Sofia", "Camilla", "Martina", "Mateo", "Nicolás"]
        #expect(names.allSatisfy { $0.count >= 5 } == true)
        #expect(names.allSatisfy { $0.count >= 6 } == false)
    }

    @Test func testFirstWhere() throws {
        let numbers = [3, 7, 4, -2, 9, -6, 10, 1]
        #expect(numbers.first { $0 < 0 } == -2)
    }

    @Test func testMin() throws {
        let heights = [67.5, 65.7, 64.3, 61.1, 58.5, 60.3, 64.9]
        #expect(heights.min() == 58.5)
    }

    @Test func testMinBy() throws {
        let hues = ["Heliotrope": 296, "Coral": 16, "Aquamarine": 156]
        let leastHue = hues.min { a, b in a.value < b.value }
        #expect(leastHue! == (key: "Coral", value: 16))
    }

    @Test func testMax() throws {
        let heights = [67.5, 65.7, 64.3, 61.1, 58.5, 60.3, 64.9]
        #expect(heights.max() == 67.5)
    }

    @Test func testMaxBy() throws {
        let hues = ["Heliotrope": 296, "Coral": 16, "Aquamarine": 156]
        let greatestHue = hues.max { a, b in a.value < b.value }
        #expect(greatestHue! == (key: "Heliotrope", value: 296))
    }
}
