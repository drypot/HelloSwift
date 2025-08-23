//
//  OptionalTests.swift
//  HelloSwiftTests
//
//  Created by Kyuhyun Park on 11/12/24.
//

import Foundation
import Testing

// https://developer.apple.com/documentation/swift/optional
// enum Optional<Wrapped> where Wrapped : ~Copyable

struct OptionalTests {

    @Test func testOptional() throws {
        let number1: Int? = Int("42")  // short form
        let number2: Optional<Int> = Int("42") // long form

        #expect(number1 == number2)
        #expect(number1 == Optional(42))
        #expect(number1 == Optional.some(42))
        #expect(number1 == .some(42))
        #expect(number1 == 42)

        let noNumber1: Int? = Int("xx")  // nil

        #expect(noNumber1 == nil)
        #expect(noNumber1 == Optional.none)
        #expect(noNumber1 == .none)
    }

    @Test func testOptionalBinding() throws {
        if let number = Int("42") {
            #expect(number == 42)
        } else {
            fatalError()
        }

        if let number = Int("xx") {
            _ = number
            fatalError()
        } else {
            // number is nil
        }
    }

    @Test func testOptionalChaining() throws {
        #expect(Int("42")?.advanced(by: 10) == 52)
        #expect(Int("xx")?.advanced(by: 10) == nil)
    }

    @Test func testNilCoalescingOperator() throws {
        // 컴파일할 때 시간 많이 걸린다는 경고가 떠서 타입을 모두 입혔다.
        #expect(Int("42") ?? Int(0) == Int(42))
        #expect(Int("xx") ?? Int(0) == Int(0))
        #expect(Int("xx") ?? Int("42") ?? Int(0) == Int(42))
        #expect(Int("xx") ?? Int("xx") ?? Int(0) == Int(0))
    }

    @Test func testUnconditionalUnwrapping() throws {
        let number = Int("42")!

        #expect(number == 42)

        // 익셉션으로 잡을 수 있는 것이 아닌가 보다. 런타임에 그냥 터진다.
        //
        // #expect(throws: (any Error).self) {
        //     Int("xx")!
        // }
    }

    @Test func testMap() throws {
        #expect(Int("10").map { $0 * 2 } == 20)
        #expect(Int("xx").map { $0 * 2 } == nil)
    }
}
