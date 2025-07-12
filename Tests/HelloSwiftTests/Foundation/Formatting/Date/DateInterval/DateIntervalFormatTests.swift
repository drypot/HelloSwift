//
//  DateIntervalFormatTests.swift
//  HelloSwiftTests
//
//  Created by Kyuhyun Park on 10/25/24.
//

import Foundation
import Testing

// Data Formatting
// https://developer.apple.com/documentation/foundation/data_formatting

struct DateIntervalFormatTests {

    // 2024-10-24 08:30:10 +0000
    // 2024-10-24 17:30:10 +0900
    let date1410 = Date(timeIntervalSinceReferenceDate: 751451410.0)

    @Test func testFactory() throws {
        let calendar = Calendar(identifier: .gregorian)

        let range = date1410 ..< calendar.date(byAdding: .day, value: 30, to: date1410)!

        // https://developer.apple.com/documentation/foundation/formatstyle/3796518-interval
        // interval: A convenience factory variable to use as a base for custom date interval format styles.

        #expect(range.formatted(.interval) == "2024. 10. 24. 오후 5:30 ~ 2024. 11. 23. 오후 5:30")
        #expect(range.formatted(.interval.month(.wide).day()) == "10월 24일 ~ 11월 23일")
    }

    @Test func testPredefined() throws {
        let calendar = Calendar(identifier: .gregorian)

        let range = date1410 ..< calendar.date(byAdding: .day, value: 30, to: date1410)!

        #expect(range.formatted() == "2024. 10. 24. 오후 5:30 ~ 2024. 11. 23. 오후 5:30")

        #expect(range.formatted(date: .numeric, time: .omitted)     == "2024. 10. 24. ~ 2024. 11. 23.")
        #expect(range.formatted(date: .abbreviated, time: .omitted) == "2024년 10월 24일 ~ 11월 23일")
        #expect(range.formatted(date: .long, time: .omitted)        == "2024년 10월 24일 ~ 11월 23일")
        #expect(range.formatted(date: .complete, time: .omitted)    == "2024년 10월 24일 목요일 ~ 11월 23일 토요일")

        #expect(range.formatted(date: .omitted, time: .shortened)   == "2024. 10. 24. 오후 5:30 ~ 2024. 11. 23. 오후 5:30")
        #expect(range.formatted(date: .omitted, time: .standard)    == "2024. 10. 24. 오후 5:30:10 ~ 2024. 11. 23. 오후 5:30:10")
        #expect(range.formatted(date: .omitted, time: .complete)    == "2024. 10. 24. 오후 5시 30분 10초 GMT+9 ~ 2024. 11. 23. 오후 5시 30분 10초 GMT+9")

        let range2 = date1410 ..< calendar.date(byAdding: .hour, value: 3, to: date1410)!

        #expect(range2.formatted(date: .omitted, time: .shortened)   == "오후 5:30~8:30")
        #expect(range2.formatted(date: .omitted, time: .standard)    == "오후 5:30:10 ~ 오후 8:30:10")
        #expect(range2.formatted(date: .omitted, time: .complete)    == "오후 5시 30분 10초 GMT+9 ~ 오후 8시 30분 10초 GMT+9")
    }

    @Test func testPredefined2() throws {
        let calendar = Calendar(identifier: .gregorian)

        let style = Date.IntervalFormatStyle(
            date: .abbreviated,
            time: .shortened,
            locale: Locale(identifier: "ko_KR"),
            calendar: calendar,
            timeZone: TimeZone(identifier: "Asia/Seoul")!
        )

        let range = date1410 ..< calendar.date(byAdding: .day, value: 30, to: date1410)!

        #expect(range.formatted(style) == "2024년 10월 24일 오후 5:30 ~ 2024년 11월 23일 오후 5:30")
    }

    @Test func testModifiers() throws {
        let calendar = Calendar(identifier: .gregorian)

        let style = Date.IntervalFormatStyle(
            locale: Locale(identifier: "ko_KR"),
            calendar: calendar,
            timeZone: TimeZone(identifier: "Asia/Seoul")!
        ).month(.wide).day().weekday(.short).hour(.conversationalTwoDigits(amPM: .wide))

        let range = date1410 ..< calendar.date(byAdding: .day, value: 30, to: date1410)!

        #expect(range.formatted(style) == "10월 24일 (목) 오후 5시 ~ 11월 23일 (토) 오후 5시")
    }

}
