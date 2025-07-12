//
//  Swift5StringInterpolationTests.swift
//  HelloSwiftTests
//
//  Created by Kyuhyun Park on 10/27/24.
//

import Foundation
import Testing

// 커스텀 스트링을 만드는 Swift 5 이후 방식

// ExpressibleByStringInterpolation 프로토콜을 준수하는 타입들은
// StringInterpolation 에서 인스턴스를 생성할 수 있게 된다.

// ExpressibleByStringInterpolation 타입들은, 당연하게도, 대표적으로 String,
// StringInterpolation 서브 타입을 갖는다, 예로 String.StringInterpolation,

// String 의 String.StringInterpolation 은 DefaultStringInterpolation 의 typealias 이다.
// DefaultStringInterpolation 을 확장하면 모든 string interpolation 수식에서 확장 기능을 사용할 수 있다.

// https://www.hackingwithswift.com/articles/178/super-powered-string-interpolation-in-swift-5-0

struct Swift5StringInterpolationTests {

    @Test func testSwiftConvertsExpressionToStatements() throws {

        let string1 = "The time is \(12)."

        // 컴파일러는 "The time is \(time)." 수식을 아래 비슷한 코드로 해체한다.

        var interpolation = String.StringInterpolation(literalCapacity: 13, interpolationCount: 1)

        interpolation.appendLiteral("The time is ")
        interpolation.appendInterpolation(12)
        interpolation.appendLiteral(".")

        let string2 = String(stringInterpolation: interpolation)

        #expect(string1 == "The time is 12.")
        #expect(string2 == "The time is 12.")
    }

}

// StringInterpolation 을 가장 쉽게 확장하려면
// DefaultStringInterpolation 을 확장하면 된다.

extension DefaultStringInterpolation {

    mutating func appendInterpolation(test value: Int, using style: NumberFormatter.Style) {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.numberStyle = style

        guard let result = formatter.string(from: value as NSNumber)  else { return }
        appendLiteral(result)
    }

}

struct ExtendingDefaultStringInterpolationTests {

    @Test func test() throws {
        #expect("\(test: 123, using: .spellOut)" == "one hundred twenty-three")
    }

}

// 본격적으로 StringInterpolation 에서 오브젝트를 생성하려면 아래처럼 한 세트를 만들어야 한다.

struct ExpressibleByStringInterpolationTests {

    struct LiteralAndValue: ExpressibleByStringInterpolation, Equatable {

        var literal: String
        var value: Int

        struct StringInterpolation: StringInterpolationProtocol {
            var literal: String = ""
            var value: Int = 0

            init(literalCapacity: Int, interpolationCount: Int) {
            }

            mutating func appendLiteral(_ literal: String) {
                self.literal += literal
            }

            mutating func appendInterpolation(_ value: Int) {
                self.value += value
            }

            mutating func appendInterpolation(_ value1: Int, _ value2: Int) {
                self.value += (value1 * value2)
            }
        }

        init(stringLiteral value: String) {
            self.literal = value
            self.value = 0
        }

        init(stringInterpolation: StringInterpolation) {
            self.literal = stringInterpolation.literal
            self.value = stringInterpolation.value
        }
    }

    @Test func test() {
        let lv1: LiteralAndValue = "Value1: \(100), Value2: \(3, 2)"

        #expect(lv1.literal == "Value1: , Value2: ")
        #expect(lv1.value == 106)

        let lv2 = "Value1: \(100), Value2: \(3, 2)" as LiteralAndValue

        #expect(lv1 == lv2)
    }
}

// 다 생략하고 init(stringLiteral:) 만 정의하면
// DefaultStringInterpolation 을 사용한다.

struct ExpressibleByStringLiteralTests {

    struct LiteralAndValue: ExpressibleByStringInterpolation {

        var literal: String

        init(stringLiteral value: String) {
            self.literal = value
        }

    }

    @Test func test() {
        let lv: LiteralAndValue = "Value1: \(100), Value2: \(22)"

        #expect(lv.literal == "Value1: 100, Value2: 22")
    }
}
