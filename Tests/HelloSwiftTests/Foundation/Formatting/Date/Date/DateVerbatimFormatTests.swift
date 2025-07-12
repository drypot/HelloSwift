//
//  DateVerbatimFormatTests.swift
//  HelloSwiftTests
//
//  Created by Kyuhyun Park on 10/29/24.
//

import Foundation
import Testing

// Data Formatting
// https://developer.apple.com/documentation/foundation/data_formatting

// https://developer.apple.com/documentation/foundation/date/verbatimformatstyle/
// https://developer.apple.com/documentation/foundation/date/formatstring
// https://developer.apple.com/documentation/foundation/date/formatstring/stringinterpolation

struct DateVerbatimFormatTests {

    // 2024-10-24 08:30:10 +0000
    // 2024-10-24 17:30:10 +0900
    let date1410 = Date(timeIntervalSinceReferenceDate: 751451410.0)

    @Test func testFormatStyleWithDefaults() throws {
        let style = Date.VerbatimFormatStyle(
            format: "\(year: .defaultDigits)-\(month: .twoDigits)-\(day: .twoDigits) \(hour: .twoDigits(clock: .twentyFourHour, hourCycle: .zeroBased)):\(minute: .twoDigits):\(second: .twoDigits)",
            timeZone: TimeZone(identifier: "Asia/Seoul")!,
            calendar: Calendar(identifier: .gregorian)
        )

        #expect(date1410.formatted(style) == "2024-10-24 17:30:10")
        #expect(style.format(date1410) == "2024-10-24 17:30:10")
    }
}
