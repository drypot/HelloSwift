//
//  ClosureTests.swift
//  HelloSwiftTests
//
//  Created by Kyuhyun Park on 10/22/24.
//

import Testing

struct ClosureTests {

    @Test func testClosure() throws {

        struct A {
            let param: Int

            func multiply(to value:Int) -> Int {
                return value * param
            }
        }

        func multiplyTen(to value:Int) -> Int {
            return value * 10
        }

        func apply(value:Int, f: (Int) -> Int) -> Int {
            return f(value)
        }

        let a = A(param: 20)
        let b = A(param: 30)

        #expect(apply(value: 10, f: multiplyTen(to:)) == 100)

        #expect(apply(value: 10, f: a.multiply(to:)) == 200)
        #expect(apply(value: 10, f: b.multiply(to:)) == 300)

        #expect(apply(value: 10, f: { value in return value * 40 }) == 400)
        #expect(apply(value: 10, f: { $0 * 50 }) == 500)
    }

}
