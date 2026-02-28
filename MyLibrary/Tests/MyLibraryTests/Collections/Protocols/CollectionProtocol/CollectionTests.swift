//
//  CollectionTests.swift
//  HelloSwiftTests
//
//  Created by Kyuhyun Park on 11/10/24.
//

import Foundation
import Testing

struct CollectionTests {

    @Test func testEmpty() throws {
        let collection = [Int]()

        #expect(collection.isEmpty == true)
        #expect(collection.count == 0)
        #expect(collection.first == nil)
    }

    @Test func testCollection() throws {
        let collection = [0, 1, 2, 3, 4, 5]

        #expect(collection.isEmpty == false)
        #expect(collection.count == 6)
        #expect(collection.first == 0)
    }

    @Test func testRemoveFirst() throws {
        var collection = [0, 1, 2, 3, 4, 5]
        var element: Int

        element = collection.removeFirst()

        #expect(element == 0)
        #expect(collection == [1, 2, 3, 4, 5])

        element = collection.removeFirst()

        #expect(element == 1)
        #expect(collection == [2, 3, 4, 5])

        // Available when Self is Self.SubSequence.
        //
        // value = array.popFirst()
        // array.removeFirst(3)
    }

}
