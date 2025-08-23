//
//  TypeAliasTests.swift
//  HelloSwiftTests
//
//  Created by Kyuhyun Park on 10/23/24.
//

import Foundation
import Testing

struct TypeAliasTests {

    @Test func testComplexType() throws {
        typealias IntOp = (Int, Int) -> Int
        func sum(a: Int, b: Int) -> Int { a + b }
        let f : IntOp = sum

        #expect(f(1, 2) == 3)
    }

    @Test func testTuple() throws {
        typealias Coordinates = (latitude: Double, longitude: Double)
        let location: Coordinates = (latitude: 37.7749, longitude: -122.4194)

        #expect(location.latitude == 37.7749)
    }

    @Test func testGeneric() throws {
        typealias MyResult = Result<Int, Error>
        let result: MyResult = .success(10)

        switch result {
        case .failure:
            fatalError()
        case .success(let value):
            #expect(value == 10)
        }
    }

    @Test func testAssociatedType() throws {
        protocol Drawable {
            associatedtype Shape
            func draw(shape: Shape)
        }

        struct Circle { }

        struct CircleDrawer: Drawable {
            typealias Shape = Circle // ...
            func draw(shape: Circle) { }
        }
    }
}
