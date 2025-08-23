//
//  ISO8601FormatterTests.swift
//  HelloSwiftTests
//
//  Created by Kyuhyun Park on 10/25/24.
//

import Foundation
import Testing

// In Swift, you can use Date.ISO8601FormatStyle rather than ISO8601DateFormatter.

struct ISO8601FormatterTests {

    // 2024-10-24 08:30:10 +0000
    // 2024-10-24 17:30:10 +0900
    let date = Date(timeIntervalSinceReferenceDate: 751451410.0)

    @Test func testTimeZone() throws {
        let formatter = ISO8601DateFormatter()

        #expect(formatter.string(from: date) == "2024-10-24T08:30:10Z")

        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")!
        #expect(formatter.string(from: date) == "2024-10-24T17:30:10+09:00")
    }

    @Test func testOptions() throws {
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")!

        formatter.formatOptions = [.withFullDate, .withFullTime]
        #expect(formatter.string(from: date) == "2024-10-24T17:30:10+09:00")

        formatter.formatOptions = [.withFullDate, .withFullTime, .withSpaceBetweenDateAndTime]
        #expect(formatter.string(from: date) == "2024-10-24 17:30:10+09:00")

        formatter.formatOptions = [.withInternetDateTime]
        #expect(formatter.string(from: date) == "2024-10-24T17:30:10+09:00")

        formatter.formatOptions = [.withYear, .withMonth, .withDay, .withTime]
        #expect(formatter.string(from: date) == "20241024T173010")

        formatter.formatOptions = [.withYear, .withMonth, .withDay, .withTime, .withSpaceBetweenDateAndTime]
        #expect(formatter.string(from: date) == "20241024 173010")

        formatter.formatOptions = [
            .withYear, .withMonth, .withDay, .withTime,
            .withDashSeparatorInDate,
            .withSpaceBetweenDateAndTime,
        ]
        #expect(formatter.string(from: date) == "2024-10-24 173010")

        formatter.formatOptions = [
            .withYear, .withMonth, .withDay, .withTime,
            .withDashSeparatorInDate,
            .withSpaceBetweenDateAndTime,
            .withColonSeparatorInTime,
        ]
        #expect(formatter.string(from: date) == "2024-10-24 17:30:10")

        formatter.formatOptions = [
            .withYear, .withMonth, .withDay, .withTime, .withTimeZone,
            .withDashSeparatorInDate,
            .withSpaceBetweenDateAndTime,
            .withColonSeparatorInTime,
        ]
        #expect(formatter.string(from: date) == "2024-10-24 17:30:10+0900")

        formatter.formatOptions = [
            .withYear, .withMonth, .withDay, .withTime, .withTimeZone,
            .withDashSeparatorInDate,
            .withSpaceBetweenDateAndTime,
            .withColonSeparatorInTime,
            .withColonSeparatorInTimeZone,
        ]
        #expect(formatter.string(from: date) == "2024-10-24 17:30:10+09:00")
    }

}
