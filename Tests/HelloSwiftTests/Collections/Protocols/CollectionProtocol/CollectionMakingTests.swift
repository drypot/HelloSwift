//
//  CollectionMakingTests.swift
//  HelloSwiftTests
//
//  Created by Kyuhyun Park on 11/4/24.
//

import Foundation
import Testing

// protocol Collection<Element> : Sequence
// 
// A sequence whose elements can be accessed by an indexed subscript.
//
// https://github.com/swiftlang/swift/blob/main/stdlib/public/core/Collection.swift

struct CollectionMakingTests {

    @Test func testSimpleCustomCollection() throws {

        struct CustomCollection: Collection {
            typealias Element = Int
            typealias Index = Int

            private var elements: [Element]

            init(_ elements: [Element]) {
                self.elements = elements
            }

            var startIndex: Index {
                return elements.startIndex
            }

            var endIndex: Index {
                return elements.endIndex
            }

            func index(after i: Index) -> Index {
                return elements.index(after: i)
            }

            subscript(position: Index) -> Element {
                return elements[position]
            }
        }

        let collection = CustomCollection([10, 20, 30, 40])

        var index: CustomCollection.Index

        index = collection.startIndex
        #expect(collection[index] == 10)

        index = collection.index(after: index)
        #expect(collection[index] == 20)

        index = collection.index(after: index)
        #expect(collection[index] == 30)

        index = collection.index(after: index)
        #expect(collection[index] == 40)

        index = collection.index(after: index)
        #expect(index == collection.endIndex)
    }
    
//    let text = "Buffalo buffalo buffalo buffalo."
//
//    @Test func testStartIndex() throws {
//        #expect(text[text.startIndex] == "B")
//        #expect(text.first == "B")
//    }
//
//    @Test func testRangedSubscript() throws {
//        let firstSpace = text.firstIndex(of: " ") ?? text.endIndex
//        let firstWord = text[..<firstSpace]
//        #expect(firstWord == "Buffalo")
//    }
//
//    @Test func testPrefix() throws {
//        let firstWord = text.prefix { $0 != " " }
//        #expect(firstWord == "Buffalo")
//    }

    
}
