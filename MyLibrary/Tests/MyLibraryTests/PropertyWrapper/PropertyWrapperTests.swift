//
//  PropertyWrapperTests.swift
//  HelloSwift
//
//  Created by Kyuhyun Park on 11/24/25.
//

import Foundation
import Testing

// https://docs.swift.org/swift-book/documentation/the-swift-programming-language/properties/
// https://docs.swift.org/swift-book/documentation/the-swift-programming-language/properties/#Property-Wrappers

// A property wrapper adds a layer of separation between
// code that manages how a property is stored and
// the code that defines a property.

struct PropertyWrapperTests {

    @Test func testPropertyWrapper() throws {
        @propertyWrapper             // @propertyWrapper
        struct TwelveOrLess {        // TwelveOrLess
            private var number = 0
            var wrappedValue: Int {  // wrappedValue
                get { return number }
                set { number = min(newValue, 12) }
            }
        }

        struct SmallRectangle {
            @TwelveOrLess var height: Int  // @TwelveOrLess
            @TwelveOrLess var width: Int
        }

        var rectangle = SmallRectangle()
        #expect(rectangle.height == 0)

        rectangle.height = 10
        #expect(rectangle.height == 10)

        rectangle.height = 24
        #expect(rectangle.height == 12)
    }

    @Test func testPropertyWrapperExplicit() throws {
        @propertyWrapper             // @propertyWrapper
        struct TwelveOrLess {        // TwelveOrLess
            private var number = 0
            var wrappedValue: Int {  // wrappedValue
                get { return number }
                set { number = min(newValue, 12) }
            }
        }

        struct SmallRectangle {
            private var _height = TwelveOrLess()  // TwelveOrLess
            private var _width = TwelveOrLess()
            var height: Int {
                get { return _height.wrappedValue }
                set { _height.wrappedValue = newValue }
            }
            var width: Int {
                get { return _width.wrappedValue }
                set { _width.wrappedValue = newValue }
            }
        }

        var rectangle = SmallRectangle()
        #expect(rectangle.height == 0)

        rectangle.height = 10
        #expect(rectangle.height == 10)

        rectangle.height = 24
        #expect(rectangle.height == 12)
    }

    @Test func testSettingInitialValues() throws {
        @propertyWrapper
        struct SmallNumber {
            private var maximum: Int
            private var number: Int

            var wrappedValue: Int {
                get { return number }
                set { number = min(newValue, maximum) }
            }

            init() {
                maximum = 12
                number = 0
            }

            init(wrappedValue: Int) {
                maximum = 12
                number = min(wrappedValue, maximum)
            }

            init(wrappedValue: Int, maximum: Int) {
                self.maximum = maximum
                number = min(wrappedValue, maximum)
            }
        }

        struct ZeroRectangle {
            @SmallNumber var height: Int   // SmallNumber.init() 로 초기화
            @SmallNumber var width: Int
        }

        let zeroRectangle = ZeroRectangle()
        #expect(zeroRectangle.height == 0)

        struct UnitRectangle {
            @SmallNumber var height: Int = 1   // SmallNumber.init(wrappedValue: Int) 로 초기화
            @SmallNumber var width: Int = 1
        }

        let unitRectangle = UnitRectangle()
        #expect(unitRectangle.height == 1)

        struct NarrowRectangle {
            @SmallNumber(wrappedValue: 2, maximum: 5) var height: Int   // SmallNumber.init(wrappedValue: Int, maximum: Int) 로 초기화
            @SmallNumber(maximum: 4) var width: Int = 3                 // SmallNumber.init(wrappedValue: Int, maximum: Int) 로 초기화
        }

        var narrowRectangle = NarrowRectangle()
        #expect(narrowRectangle.height == 2)
        #expect(narrowRectangle.width == 3)

        narrowRectangle.height = 10
        narrowRectangle.width = 10
        #expect(narrowRectangle.height == 5)
        #expect(narrowRectangle.width == 4)
    }

    @Test func testProjectingValues() {
        @propertyWrapper                 // @propertyWrapper
        struct SmallNumber {             // SmallNumber
            private var number: Int
            private(set) var projectedValue: Bool  // projectedValue

            var wrappedValue: Int {      // wrappedValue
                get { return number }
                set {
                    if newValue > 12 {
                        number = 12
                        projectedValue = true
                    } else {
                        number = newValue
                        projectedValue = false
                    }
                }
            }

            init() {
                self.number = 0
                self.projectedValue = false
            }
        }

        struct SomeStructure {
            @SmallNumber var someNumber: Int  // @SmallNumber
        }

        var someStructure = SomeStructure()
        #expect(someStructure.someNumber == 0)
        #expect(someStructure.$someNumber == false)

        someStructure.someNumber = 4
        #expect(someStructure.someNumber == 4)
        #expect(someStructure.$someNumber == false)

        someStructure.someNumber = 55
        #expect(someStructure.someNumber == 12)
        #expect(someStructure.$someNumber == true)
    }
}
