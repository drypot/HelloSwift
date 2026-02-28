//
//  DateTests.swift
//  HelloSwiftTests
//
//  Created by Kyuhyun Park on 10/23/24.
//

import Foundation
import Testing

struct DateTests {

    // 2024-10-24 08:30:10 +0000
    // 2024-10-24 17:30:10 +0900
    let date1410 = Date(timeIntervalSinceReferenceDate: 751451410.0)

    @Test func testCalendar() throws {
        let _ = Calendar.current

        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!

        #expect(calendar.identifier == .gregorian)
    }

    @Test func testTimeZone() throws {
        let _ = TimeZone.current

        let timeZone = TimeZone(identifier: "Asia/Seoul")!

        #expect(timeZone.identifier == "Asia/Seoul")

        // secondsFromGMT 은 Date 를 요구하는데 Daylight Saving Time 을 사용하는 지역 때문에 그렇다.
        // 한국은 서머 타임이 없으므로 인자 없이 쓰면 된다.

        #expect(timeZone.secondsFromGMT() == 60*60*9) // 9시간 차

        #expect(timeZone.localizedName(for: .generic, locale: Locale(identifier: "ko_KR")) == "대한민국 표준시")

        #expect(timeZone.localizedName(for: .generic, locale: Locale(identifier: "en_US")) == "Korean Standard Time")
    }

    @Test func testLocale() throws {
        let _ = Locale.current

        let locale = Locale(identifier: "ko_KR")

        #expect(locale.identifier == "ko_KR")
    }

    // DateComponents ...

    @Test func testDateComponents() throws {
        var components1 = DateComponents()
        components1.year = 2024
        components1.month = 10
        components1.day = 24
        components1.hour = 17
        components1.minute = 30
        components1.second = 10

        let components2 = DateComponents(year: 2024, month: 10, day: 24, hour: 17, minute: 30, second: 10)

        #expect(components1 == components2)
    }

    @Test func testDateFromComponents() throws {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!

        let components = DateComponents(year: 2024, month: 10, day: 24, hour: 17, minute: 30, second: 10)
        let date = calendar.date(from: components)!

        #expect(date == date1410)
    }

    @Test func testDateFromComponents2() throws {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!

        let components = DateComponents(
            calendar: calendar,
            timeZone: calendar.timeZone,
            year: 2024, month: 10, day: 24, hour: 17, minute: 30, second: 10
        )
        let date = components.date

        #expect(date == date1410)
    }

    @Test func testComponentsFromDate() throws {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!

        do {
            let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date1410)

            #expect(components.year == 2024)
            #expect(components.month == 10)
            #expect(components.day == 24)
            #expect(components.hour == 17)
            #expect(components.minute == 30)
            #expect(components.second == 10)
        }

        do {
            // 타임존 넣는 매서드 사용하면 모든 Component 가 싹 들어온다.
            let components = calendar.dateComponents(in: calendar.timeZone, from: date1410)

            #expect(components.year == 2024)
            #expect(components.month == 10)
            #expect(components.day == 24)
            #expect(components.hour == 17)
            #expect(components.minute == 30)
            #expect(components.second == 10)
        }

        do {
            #expect(calendar.component(.year, from: date1410) == 2024)
            #expect(calendar.component(.month, from: date1410) == 10)
            #expect(calendar.component(.day, from: date1410) == 24)
            #expect(calendar.component(.hour, from: date1410) == 17)
            #expect(calendar.component(.minute, from: date1410) == 30)
            #expect(calendar.component(.second, from: date1410) == 10)
        }
    }

    @Test func testDateArithmetic() throws {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!

        let components1 = DateComponents(year: 2024, month: 10, day: 24, hour: 17, minute: 30, second: 10)
        let date1 = calendar.date(from: components1)!

        do {
            let date2 = calendar.date(byAdding: DateComponents(day: 10), to: date1)!
            let components2 = calendar.dateComponents([.year, .month, .day, .hour], from: date2)

            #expect(components2.year == 2024)
            #expect(components2.month == 11)
            #expect(components2.day == 3)
            #expect(components2.hour == 17)
        }

        do {
            let date2 = calendar.date(byAdding: .day, value: 10, to: date1)!
            let components2 = calendar.dateComponents([.year, .month, .day, .hour], from: date2)

            #expect(components2.year == 2024)
            #expect(components2.month == 11)
            #expect(components2.day == 3)
            #expect(components2.hour == 17)
        }

        do {
            let date2 = calendar.date(bySetting: .month, value: 12, of: date1)!
            let components2 = calendar.dateComponents([.year, .month, .day, .hour], from: date2)

            #expect(components2.year == 2024)
            #expect(components2.month == 12)
            #expect(components2.day == 1) // not 24
            #expect(components2.hour == 0) // not 17
        }
    }

    @Test func testDateComparison() throws {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!

        let components1 = DateComponents(year: 2024, month: 10, day: 24, hour: 17, minute: 30, second: 10)
        let date1 = calendar.date(from: components1)!

        let components2 = DateComponents(year: 2024, month: 10, day: 24, hour: 23, minute: 30, second: 10)
        let date2 = calendar.date(from: components2)!

        #expect(calendar.isDate(date1, inSameDayAs: date2) == true)
        #expect(calendar.isDate(date1, equalTo: date2, toGranularity: .day) == true)
        #expect(calendar.isDate(date1, equalTo: date2, toGranularity: .hour) == false)
    }

    @Test func testDateDiff() throws {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!

        let components1 = DateComponents(year: 2000, month: 7, day: 18, hour: 15, minute: 10, second: 3)
        let date1 = calendar.date(from: components1)!

        let components2 = DateComponents(year: 2024, month: 10, day: 24, hour: 23, minute: 30, second: 10)
        let date2 = calendar.date(from: components2)!

        do {
            let diff = calendar.dateComponents([.year, .month, .day, .hour], from: components1, to: components2)
            #expect(diff.year == 24)
            #expect(diff.month == 3)
            #expect(diff.day == 6)
            #expect(diff.hour == 8)
        }
        do {
            let diff = calendar.dateComponents([.year, .month, .day, .hour], from: date1, to: date2)
            #expect(diff.year == 24)
            #expect(diff.month == 3)
            #expect(diff.day == 6)
            #expect(diff.hour == 8)
        }
    }

    @Test func testOrdinality() throws {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!

        do {
            let components = DateComponents(hour: 22)
            let date = calendar.date(from: components)!
            let next = calendar.ordinality(of: .hour, in: .day, for: date)!

            #expect(next == 23)
        }
        do {
            let components = DateComponents(hour: 23)
            let date = calendar.date(from: components)!
            let next = calendar.ordinality(of: .hour, in: .day, for: date)!

            #expect(next == 24)
        }
        do {
            let components = DateComponents(hour: 24)
            let date = calendar.date(from: components)!
            let next = calendar.ordinality(of: .hour, in: .day, for: date)!

            #expect(next == 1)
        }
    }

    @Test func testStartOfDay() throws {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!

        let date = calendar.startOfDay(for: date1410)
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)

        #expect(components.year == 2024)
        #expect(components.month == 10)
        #expect(components.day == 24)
        #expect(components.hour == 0)  // not 17
        #expect(components.minute == 0)  // not 30
        #expect(components.second == 0)  // not 10
    }

    // Date ...

    @Test func testReferenceDate() throws {
        // TimeInterval = Double

        // 2001-01-01
        let referenceDate = Date(timeIntervalSinceReferenceDate: 0)

        #expect(referenceDate.timeIntervalSinceReferenceDate == 0)
        #expect(referenceDate.timeIntervalSince1970 == 978307200.0)
        #expect(referenceDate.timeIntervalSince1970 == Date.timeIntervalBetween1970AndReferenceDate)

        // 2024-10-24 08:30:10 +0000
        // 2024-10-24 17:30:10 +0900
        let date = Date(timeIntervalSinceReferenceDate: 751451410.0)

        #expect(date.timeIntervalSinceReferenceDate == 751451410.0)
        #expect(date.timeIntervalSince1970 == 1729758610.0)

        #expect(date.timeIntervalSince(referenceDate) == 751451410.0)  // TimeInterval = Double

        #expect(referenceDate.distance(to: date) == 751451410.0)  // TimeInterval = Double
    }

    @Test func testMakingNow() throws {

        // Swift’s Date type does not include information about time zones or calendar systems

        let now1 = Date()
        let now2 = Date.now
        let now3 = Date(timeIntervalSinceNow: 0)

        #expect(now2.timeIntervalSince(now1) < 3)
        #expect(now3.timeIntervalSince(now1) < 3)
    }

    @Test func testMakingTomorrow() throws {
        let now = Date.now
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: now)!
        let tomorrow2 = now + 60*60*24
        let tomorrow3 = Date(timeInterval: 60*60*24, since: now) /* in seconds */
        let tomorrow4 = now.addingTimeInterval(60*60*24)
        let tomorrow5 = now.advanced(by: 60*60*24)

        #expect(tomorrow == tomorrow2)
        #expect(tomorrow == tomorrow3)
        #expect(tomorrow == tomorrow4)
        #expect(tomorrow == tomorrow5)
    }

}
