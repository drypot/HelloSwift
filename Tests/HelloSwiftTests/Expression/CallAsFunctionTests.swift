//
//  CallAsFunctionTests.swift
//  HelloSwiftTests
//
//  Created by Kyuhyun Park on 11/19/24.
//

import Foundation
import Testing

// https://docs.swift.org/swift-book/documentation/the-swift-programming-language/declarations/#Methods-with-Special-Names

struct CallAsFunctionTests {

    @Test func test() throws {

        struct CallableStruct {
            var value: Int
            func callAsFunction(scale: Int) -> Int{
                return value * scale
            }
        }

        let callable = CallableStruct(value: 100)

        #expect(callable(scale: 2) == 200)
        #expect(callable.callAsFunction(scale: 2) == 200)

    }

}
