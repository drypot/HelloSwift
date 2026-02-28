//
//  DecimalFormatTests.swift
//  HelloSwiftTests
//
//  Created by Kyuhyun Park on 10/29/24.
//

import Foundation
import Testing

// Data Formatting
// https://developer.apple.com/documentation/foundation/data_formatting

// Decimal.FormatStyle
// https://developer.apple.com/documentation/foundation/decimal/formatstyle

// Double: Ideal for scientific calculations, graphics, and other performance-critical applications where small precision errors are acceptable.

// Decimal: Preferred for financial calculations, accounting, and other applications where precision is crucial.

struct DecimalFormatTests {

    @Test func testFactory() throws {
        let number: Decimal = 0.1

        // https://developer.apple.com/documentation/foundation/formatstyle/3796532-number
        // number: A style for formatting decimal values.

        #expect(number.formatted() == "0.1")

        #expect(number.formatted(.number) == "0.1")

        #expect(number.formatted(.percent) == "10%")

        #expect(number.formatted(.currency(code:"KRW")) == "₩0")
        #expect(number.formatted(.currency(code:"USD")) == "US$0.10")
    }

    @Test func testFloatingPointFormatStyle() throws {
        let style = Decimal.FormatStyle(locale: Locale(identifier: "ko_KR"))

        let number: Decimal = 12345.789

        #expect(style.format(number) == "12,345.789")

        #expect(number.formatted(style) == "12,345.789")

        #expect(number.formatted(style.grouping(.never)) == "12345.789")

        #expect(number.formatted(style.notation(.scientific)) == "1.234579E4")

        #expect(number.formatted(style.precision(.integerLength(3))) == "345.789")
        #expect(number.formatted(style.precision(.fractionLength(2))) == "12,345.79")
        #expect(number.formatted(style.precision(.integerAndFractionLength(integer: 5, fraction: 2))) == "12,345.79")
        #expect(number.formatted(style.precision(.significantDigits(4))) == "12,350")
        #expect(number.formatted(style.precision(.significantDigits(7))) == "12,345.79")

        #expect(Decimal(100).formatted(style) == "100")
        #expect(Decimal(100).formatted(style.decimalSeparator(strategy: .always)) == "100.")
    }

    @Test func testParsing() throws {
        let style = Decimal.FormatStyle(locale: Locale(identifier: "ko_KR"))
        let strategy = style.parseStrategy

        #expect((try strategy.parse("12345.789")) == Decimal(string: "12345.789"))
        #expect((try strategy.parse("12,345.789")) == Decimal(string: "12345.789"))

        #expect((try Decimal("12345.789", format: style)) != Decimal(12345.789))
        #expect((try Decimal("12345.789", format: style)) == Decimal(sign: .plus, exponent: -3, significand: 12345789))
        #expect((try Decimal("12345.789", format: style)) == Decimal(string: "12345.789"))

        #expect(throws: Error.self) {
            try strategy.parse("xxx")
        }
    }

}
