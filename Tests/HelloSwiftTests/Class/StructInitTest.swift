//
//  StructInitTest.swift
//  HelloSwift
//
//  Created by Kyuhyun Park on 10/14/24.
//

import Foundation
import Testing

struct StructInitTest {

    @Test func testMemberwiseInitializer() {

        // Swift automatically generates a memberwise initializer.

        struct Pet {
            let name: String
            let age: Int
        }

        let pet = Pet(name: "max", age: 3)

        #expect(pet.name == "max")
        #expect(pet.age == 3)
    }

    @Test func testCustomInitializer() {

        struct Pet {
            let name: String
            let age: Int

            init(name: String, age: Int) {
                self.name = name
                self.age = age
            }
        }

        let pet = Pet(name: "max", age: 3)

        #expect(pet.name == "max")
        #expect(pet.age == 3)
    }

    @Test func testComputedProperty() {

        struct Rectangle {
            var width: Double
            var height: Double

            var area: Double {
                return width * height
            }
        }

        let r = Rectangle(width: 10, height: 20)

        #expect(r.area == 200)
    }
}
