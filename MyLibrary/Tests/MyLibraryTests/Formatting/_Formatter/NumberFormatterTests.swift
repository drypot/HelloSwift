//
//  NumberFormatterTests.swift
//  HelloSwiftTests
//
//  Created by Kyuhyun Park on 10/25/24.
//

import Foundation
import Testing

struct NumberFormatterTests {

    @Test func testDefaults() throws {
        let formatter = NumberFormatter()

        #expect(formatter.formatterBehavior == .default)
        #expect(formatter.generatesDecimalNumbers == false)
        #expect(formatter.localizesFormat == true)

        #expect(formatter.string(from: 12345678) == "12345678")
        #expect(formatter.string(from: 1234.5678) == "1235")
        #expect(formatter.string(from: 100.2345678) == "100")
        #expect(formatter.string(from: 1.230000) == "1")
        #expect(formatter.string(from: 1.560000) == "2")
        #expect(formatter.string(from: 0.00000123) == "0")
    }

    @Test func testNumberStyles() throws {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_US")

        #expect(formatter.numberStyle == .none)
        #expect(formatter.string(from: 19.99) == "20")

        formatter.numberStyle = .decimal
        #expect(formatter.string(from: 19.99) == "19.99")

        formatter.numberStyle = .percent
        #expect(formatter.string(from: 0.25) == "25%") // 변환되기 전에 100이 곱해진다.

        formatter.numberStyle = .spellOut
        #expect(formatter.string(from: 123) == "one hundred twenty-three")

        formatter.numberStyle = .ordinal
        #expect(formatter.string(from: 3) == "3rd")

        formatter.numberStyle = .currency
        #expect(formatter.string(from: 1234.57) == "$1,234.57")

        formatter.numberStyle = .currencyISOCode
        #expect(formatter.string(from: 1234.57) == "USD 1,234.57")

        formatter.numberStyle = .currencyPlural
        #expect(formatter.string(from: 1234.57) == "1,234.57 US dollars")
    }

    @Test func testParsing() throws {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.numberStyle = .currency

        let string = formatter.string(from: 19.99)!

        #expect(string == "$19.99")

        let parsedNumber = formatter.number(from: string)

        #expect(parsedNumber == 19.99)
    }

    @Test func testMinMaxDigits() throws {
        let formatter = NumberFormatter()

        formatter.minimumIntegerDigits = 3
        formatter.maximumIntegerDigits = 3

        formatter.minimumFractionDigits = 3
        formatter.maximumFractionDigits = 3

        #expect(formatter.string(from: 12.12) == "012.120")

        #expect(formatter.string(from: 1234.1234) == "234.123")

        #expect(formatter.roundingMode == .halfEven)
        #expect(formatter.string(from: 0.1234) == "000.123")
        #expect(formatter.string(from: 0.1235) == "000.124")

        formatter.roundingMode = .ceiling
        #expect(formatter.string(from: 0.1234) == "000.124")
        #expect(formatter.string(from: 0.1235) == "000.124")

        formatter.roundingMode = .floor
        #expect(formatter.string(from: 0.1234) == "000.123")
        #expect(formatter.string(from: 0.1235) == "000.123")

        formatter.roundingMode = .halfUp
        #expect(formatter.string(from: 0.1234) == "000.123")
        #expect(formatter.string(from: 0.1235) == "000.124")
    }

    @Test func testHalfEven() throws {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 0

        #expect(formatter.roundingMode == .halfEven)

        #expect(formatter.string(from: 1.1) == "1")
        #expect(formatter.string(from: 1.5) == "2") // 2
        #expect(formatter.string(from: 1.9) == "2")

        #expect(formatter.string(from: 2.1) == "2")
        #expect(formatter.string(from: 2.4) == "2")
        #expect(formatter.string(from: 2.5) == "2") // 3 이 아니라 2 가 된다. 가능하면 짝수로 수렴.
        #expect(formatter.string(from: 2.6) == "3")
        #expect(formatter.string(from: 2.9) == "3")

        #expect(formatter.string(from: 3.1) == "3")
        #expect(formatter.string(from: 3.5) == "4") // 4
        #expect(formatter.string(from: 3.9) == "4")
    }

    @Test func testSignificantDigits() throws {
        let formatter = NumberFormatter()

        #expect(formatter.usesSignificantDigits == false)

        #expect(formatter.string(from: 12345678) == "12345678")
        #expect(formatter.string(from: 1234.5678) == "1235")
        #expect(formatter.string(from: 100.2345678) == "100")
        #expect(formatter.string(from: 1.230000) == "1")
        #expect(formatter.string(from: 1.560000) == "2")
        #expect(formatter.string(from: 0.00000123) == "0")
        #expect(formatter.string(from: 12.12) == "12")

        formatter.usesSignificantDigits = true

        #expect(formatter.minimumSignificantDigits == 1)
        #expect(formatter.maximumSignificantDigits == 6)

        #expect(formatter.string(from: 12345678) == "12345700")
        #expect(formatter.string(from: 1234.5678) == "1234.57")
        #expect(formatter.string(from: 100.2345678) == "100.235")
        #expect(formatter.string(from: 1.230000) == "1.23")
        #expect(formatter.string(from: 1.560000) == "1.56")
        #expect(formatter.string(from: 0.00000123) == "0.00000123")
        #expect(formatter.string(from: 12.12) == "12.12")
    }

}
