//
//  PercentFormatTests.swift
//  HelloSwiftTests
//
//  Created by Kyuhyun Park on 11/1/24.
//

import Foundation
import Testing

// Data Formatting
// https://developer.apple.com/documentation/foundation/data_formatting

// IntegerFormatStyle.Percent
// https://developer.apple.com/documentation/foundation/integerformatstyle/percent

// FloatingPointFormatStyle.Percent
// Decimal.FormatStyle.Percent

struct PercentFormatTests {

    @Test func testFactory() throws {

        // https://developer.apple.com/documentation/foundation/formatstyle/3870113-percent
        // percent: A style for formatting signed integer types in Swift as a percent representation.

        #expect(12345.formatted(.percent) == "12,345%")
        #expect(0.12345.formatted(.percent) == "12.345%")
    }

    @Test func testIntegerPercent() throws {
        let style = IntegerFormatStyle<Int>.Percent(locale: Locale(identifier: "ko_KR"))

        #expect(12345.formatted(style) == "12,345%")
    }

    @Test func testFloatingPointPercent() throws {
        let style = FloatingPointFormatStyle<Double>.Percent(locale: Locale(identifier: "ko_KR"))

        #expect(0.12345.formatted(style) == "12.345%")
    }

    @Test func testParsing() throws {
        let style = IntegerFormatStyle<Int>.Percent(locale: Locale(identifier: "ko_KR"))
        let strategy = style.parseStrategy

        #expect((try strategy.parse("12,345")) == 12345)
        #expect((try strategy.parse("12,345%")) == 12345)
        #expect((try strategy.parse("%12,345")) == 12345)

        #expect((try Int("12,345%", format: style)) == 12345)

        #expect(throws: Error.self) {
            try strategy.parse("$12,345")
        }
    }
    
}
