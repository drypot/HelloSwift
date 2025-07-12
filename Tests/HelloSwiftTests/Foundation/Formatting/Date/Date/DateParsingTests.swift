//
//  DateParsingTests.swift
//  HelloSwiftTests
//
//  Created by Kyuhyun Park on 10/29/24.
//

import Foundation
import Testing

// Data Formatting
// https://developer.apple.com/documentation/foundation/data_formatting

struct DateParsingTests {

    // 2024-10-24 08:30:10 +0000
    // 2024-10-24 17:30:10 +0900
    let date1410 = Date(timeIntervalSinceReferenceDate: 751451410.0)

    @Test func testParsingWithFormatStyle() throws {
        let style = Date.FormatStyle(
            locale: Locale(identifier: "ko_KR"),
            timeZone: TimeZone(identifier: "Asia/Seoul")!
        ).year().month().day().hour().minute().second()

        let string1 = date1410.formatted(style)

        #expect(string1 == "2024년 10월 24일 오후 5:30:10")

        let date1 = try! Date(string1, strategy: style)
        let date2 = try! style.parse(string1)

        #expect(date1 == date1410)
        #expect(date2 == date1410)
    }

    @Test func testParsingWithParseStrategy() throws {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "en_US")
        calendar.timeZone = TimeZone(abbreviation: "CDT")!

        let strategy = Date.ParseStrategy(
            format: "month \(month: .defaultDigits), day \(day: .twoDigits)",
            locale: Locale(identifier: "en_US"),
            timeZone: TimeZone(abbreviation: "CDT")!
        )

        let inputString = "month 8, day 23"

        let date1 = try! Date(inputString, strategy: strategy)
        let date2 = try! strategy.parse(inputString)

        #expect(date1 == date2)
        
        let components = calendar.dateComponents([.month, .day], from: date1)

        #expect(components.month == 8)
        #expect(components.day == 23)
    }

}
