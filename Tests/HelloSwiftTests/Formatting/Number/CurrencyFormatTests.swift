//
//  CurrencyFormatTests.swift
//  HelloSwiftTests
//
//  Created by Kyuhyun Park on 10/29/24.
//

import Foundation
import Testing

// Data Formatting
// https://developer.apple.com/documentation/foundation/data_formatting

// IntegerFormatStyle.Currency
// https://developer.apple.com/documentation/foundation/integerformatstyle/currency

// https://en.wikipedia.org/wiki/ISO_4217

struct CurrencyFormatTests {

    @Test func testFactory() throws {

        // https://developer.apple.com/documentation/foundation/formatstyle/3870093-currency
        // currency(code:) : Returns a format style to use integer / floating-point currency notation.

        #expect(12345.formatted(.currency(code: "KRW")) == "₩12,345")
        #expect(12345.formatted(.currency(code: "USD")) == "US$12,345.00")
    }

    @Test func testCurrency() throws {
        let style = IntegerFormatStyle<Int>.Currency(code: "KRW", locale: Locale(identifier: "ko_KR"))

        #expect(12345.formatted(style) == "₩12,345")
    }

    @Test func testCurrencyUSD() throws {
        let style = IntegerFormatStyle<Int>.Currency(code: "USD", locale: Locale(identifier: "en_US"))

        #expect(12345.formatted(style) == "$12,345.00")
    }

    @Test func testParsing() throws {
        let strategy = IntegerFormatStyle<Int>.Currency(code: "KRW").parseStrategy
        let style = IntegerFormatStyle<Int>.Currency(code: "KRW")

        #expect((try strategy.parse("₩12,345")) == 12345)

        #expect((try Int("12345", format: style)) == 12345)
        #expect((try Int("12,345", format: style)) == 12345)
        #expect((try Int("₩12,345", format: style)) == 12345)

        #expect(throws: Error.self) {
            try Int("$12,345", format: style)
        }
    }

}
