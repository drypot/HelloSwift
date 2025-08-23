//
//  DateComponentsFormatTests.swift
//  HelloSwiftTests
//
//  Created by Kyuhyun Park on 10/29/24.
//

import Foundation
import Testing

// Data Formatting
// https://developer.apple.com/documentation/foundation/data_formatting

// Date.ComponentsFormatStyle
// https://developer.apple.com/documentation/foundation/date/componentsformatstyle
// A style for formatting a date interval in terms of specific date components.

struct DateComponentsFormatTests {

    // 2024-10-24 08:30:10 +0000
    // 2024-10-24 17:30:10 +0900
    let date1410 = Date(timeIntervalSinceReferenceDate: 751451410.0)

    @Test func testFactory() throws {
        let calendar = Calendar(identifier: .gregorian)

        let duration = date1410 ..< calendar.date(byAdding: .minute, value: 90, to: date1410)!

        // https://developer.apple.com/documentation/foundation/formatstyle/3796538-timeduration
        // timeDuration: A style for formatting a duration expressed as a range of dates.

        #expect(duration.formatted(.timeDuration) == "1:30:00")
    }

    @Test func test30days() throws {
        let calendar = Calendar(identifier: .gregorian)

        var style = Date.ComponentsFormatStyle(
            style: .abbreviated,
            locale: Locale(identifier: "ko_KR"),
            calendar: calendar
        )

        let days30 = date1410 ..< calendar.date(byAdding: .day, value: 30, to: date1410)!

        #expect(days30.formatted(style) == "4주 2일")

        style.fields = [.day]
        #expect(days30.formatted(style) == "30일")

        style.fields = [.hour]
        #expect(days30.formatted(style) == "720시간")
    }

    @Test func test90Minutes() throws {
        let calendar = Calendar(identifier: .gregorian)

        var style = Date.ComponentsFormatStyle(
            style: .abbreviated,
            locale: Locale(identifier: "ko_KR"),
            calendar: calendar
        )

        let min90 = date1410 ..< calendar.date(byAdding: .minute, value: 90, to: date1410)!

        #expect(min90.formatted(style) == "1시간 30분")

        style.fields = [.hour]
        #expect(min90.formatted(style) == "1시간")

        style.fields = [.minute]
        #expect(min90.formatted(style) == "90분")

        style.fields = [.hour, .minute]
        #expect(min90.formatted(style) == "1시간 30분")
    }

    @Test func test90MinutesUS() throws {
        let calendar = Calendar(identifier: .gregorian)

        var style = Date.ComponentsFormatStyle(
            style: .abbreviated,
            locale: Locale(identifier: "en_US"),
            calendar: calendar
        )

        let min90 = date1410 ..< calendar.date(byAdding: .minute, value: 90, to: date1410)!

        #expect(min90.formatted(style) == "1 hr, 30 min")

        style.style = .condensedAbbreviated
        #expect(min90.formatted(style) == "1hr 30min")

        style.style = .narrow
        #expect(min90.formatted(style) == "1h 30m")

        style.style = .spellOut
        #expect(min90.formatted(style) == "one hour, thirty minutes")

        style.style = .wide
        #expect(min90.formatted(style) == "1 hour, 30 minutes")
    }

}
