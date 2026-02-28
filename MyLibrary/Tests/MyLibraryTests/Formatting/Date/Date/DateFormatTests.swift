//
//  DateFormatTests.swift
//  HelloSwiftTests
//
//  Created by Kyuhyun Park on 10/25/24.
//

import Foundation
import Testing

// Data Formatting
// https://developer.apple.com/documentation/foundation/data_formatting

// Date.FormatStyle
// https://developer.apple.com/documentation/foundation/date/formatstyle

struct DateFormatTests {

    // 2024-10-24 08:30:10 +0000
    // 2024-10-24 17:30:10 +0900
    let date1410 = Date(timeIntervalSinceReferenceDate: 751451410.0)

    @Test func testFactory() throws {

        // https://developer.apple.com/documentation/foundation/date/formatstyle/3798884-datetime
        // dateTime: A factory variable used as a base for custom date format styles.

        let string = date1410.formatted(.dateTime.year().month().day())
        #expect(string == "2024년 10월 24일")
    }

    @Test func testPredefined() throws {
        // Calendar, TimeZone, Locale 이 다르면 오류가 날 것이다;

        #expect(date1410.formatted() == "2024. 10. 24. 오후 5:30")

        #expect(date1410.formatted(date: .numeric, time: .omitted)     == "2024. 10. 24.")
        #expect(date1410.formatted(date: .abbreviated, time: .omitted) == "2024년 10월 24일")
        #expect(date1410.formatted(date: .long, time: .omitted)        == "2024년 10월 24일")
        #expect(date1410.formatted(date: .complete, time: .omitted)    == "2024년 10월 24일 목요일")

        #expect(date1410.formatted(date: .omitted, time: .shortened)   == "오후 5:30")
        #expect(date1410.formatted(date: .omitted, time: .standard)    == "오후 5:30:10")
        #expect(date1410.formatted(date: .omitted, time: .complete)    == "오후 5시 30분 10초 GMT+9")
    }

    @Test func testKR() throws {
        let style = Date.FormatStyle(
            locale: Locale(identifier: "ko_KR"),
            timeZone: TimeZone(identifier: "Asia/Seoul")!
        )

        #expect(style.format(date1410) == "2024. 10. 24. 오후 5:30")

        #expect(date1410.formatted(style) == "2024. 10. 24. 오후 5:30")
        #expect(date1410.formatted(style.year().month().day()) == "2024년 10월 24일")
        #expect(date1410.formatted(style.year().month().day().hour().minute().weekday()) == "2024년 10월 24일 (목) 오후 5:30")
    }

    @Test func testUS() throws {
        let style = Date.FormatStyle(
            locale: Locale(identifier: "en_US"),
            timeZone: TimeZone(identifier: "Asia/Seoul")!
        )

        #expect(style.format(date1410) == "10/24/2024, 5:30 PM")

        #expect(date1410.formatted(style) == "10/24/2024, 5:30 PM")
        #expect(date1410.formatted(style.year().month().day()) == "Oct 24, 2024")
        #expect(date1410.formatted(style.year().month().day().hour().minute().weekday()) == "Thu, Oct 24, 2024 at 5:30 PM")

        #expect(date1410.formatted(style.year().day().month(.wide)) == "October 24, 2024")
        #expect(date1410.formatted(style.weekday(.wide)) == "Thursday")
    }

    @Test func testCN() throws {
        let style = Date.FormatStyle(
            locale: Locale(identifier: "zh_CN"),
            timeZone: TimeZone(identifier: "Asia/Seoul")!
        )

        #expect(style.format(date1410) == "2024/10/24 17:30")

        #expect(date1410.formatted(style) == "2024/10/24 17:30")
        #expect(date1410.formatted(style.year().month().day()) == "2024年10月24日")
        #expect(date1410.formatted(style.year().month().day().hour().minute().weekday()) == "2024年10月24日 周四 17:30")
    }


    @Test func testJP() throws {
        let style = Date.FormatStyle(
            locale: Locale(identifier: "ja_JP"),
            timeZone: TimeZone(identifier: "Asia/Seoul")!
        )

        #expect(style.format(date1410) == "2024/10/24 17:30")

        #expect(date1410.formatted(style) == "2024/10/24 17:30")
        #expect(date1410.formatted(style.year().month().day()) == "2024年10月24日")
        #expect(date1410.formatted(style.year().month().day().hour().minute().weekday()) == "2024年10月24日(木) 17:30")
    }

}
