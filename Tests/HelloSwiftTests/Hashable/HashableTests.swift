//
//  HashableTests.swift
//  HelloSwiftTests
//
//  Created by Kyuhyun Park on 12/13/24.
//

import Foundation
import Testing

struct HashableTests {

    struct Value: Hashable {

        let id: Int

        static func == (lhs: Self, rhs: Self) -> Bool {
            return lhs.id == rhs.id
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }

    }

    @Test func test() throws {
        let value = Value(id: 10)

        print(value.hashValue)
    }

}
