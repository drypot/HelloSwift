//
//  FloatingPointFormatTests.swift
//  HelloSwiftTests
//
//  Created by Kyuhyun Park on 10/29/24.
//

import Foundation
import RegexBuilder
import Testing

// Data Formatting
// https://developer.apple.com/documentation/foundation/data_formatting

// FloatingPointFormatStyle
// https://developer.apple.com/documentation/foundation/floatingpointformatstyle

struct FloatingPointFormatTests {

    @Test func testFactory() throws {

        // https://developer.apple.com/documentation/foundation/formatstyle/3870097-number
        // number: A style for formatting the Swift standard double-precision floating-point type.

        let number = 0.1

        #expect(number.formatted() == "0.1")

        #expect(number.formatted(.number) == "0.1")

        #expect(number.formatted(.percent) == "10%")

        #expect(number.formatted(.currency(code:"KRW")) == "₩0")
        #expect(number.formatted(.currency(code:"USD")) == "US$0.10")
    }

    @Test func testFloatingPointFormatStyle() throws {
        let style = FloatingPointFormatStyle<Double>(locale: Locale(identifier: "ko_KR"))

        let number = 12345.789

        #expect(style.format(number) == "12,345.789")

        #expect(number.formatted(style) == "12,345.789")

        #expect(number.formatted(style.grouping(.never)) == "12345.789")

        #expect(number.formatted(style.notation(.scientific)) == "1.234579E4")

        #expect(number.formatted(style.precision(.integerLength(3))) == "345.789")
        #expect(number.formatted(style.precision(.fractionLength(2))) == "12,345.79")
        #expect(number.formatted(style.precision(.integerAndFractionLength(integer: 5, fraction: 2))) == "12,345.79")
        #expect(number.formatted(style.precision(.significantDigits(4))) == "12,350")
        #expect(number.formatted(style.precision(.significantDigits(7))) == "12,345.79")

        #expect(100.formatted(style) == "100")
        #expect(100.formatted(style.decimalSeparator(strategy: .always)) == "100.")
    }

    @Test func testParsing() throws {
        let style = FloatingPointFormatStyle<Double>(locale: Locale(identifier: "ko_KR"))
        let strategy = style.parseStrategy

        #expect((try strategy.parse("12345.789")) == 12345.789)
        #expect((try strategy.parse("12,345.789")) == 12345.789)

        #expect((try Double("12345.789", format: style)) == 12345.789)

        #expect(throws: Error.self) {
            try strategy.parse("₩12,345")
        }
    }

}
