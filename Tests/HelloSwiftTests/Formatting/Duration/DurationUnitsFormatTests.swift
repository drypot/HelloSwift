//
//  DurationUnitsFormatTests.swift
//  HelloSwiftTests
//
//  Created by Kyuhyun Park on 10/30/24.
//

import Foundation
import Testing

// Data Formatting
// https://developer.apple.com/documentation/foundation/data_formatting

// Duration
// https://developer.apple.com/documentation/swift/duration
// A representation of high precision time.

// Duration.UnitsFormatStyle
// https://developer.apple.com/documentation/swift/duration/unitsformatstyle

struct DurationUnitsFormatTests {

    @Test func testFactory() throws {

        // https://developer.apple.com/documentation/foundation/formatstyle/3988409-units
        // units(...) : Returns a style for formatting a duration

        // 수식을 펑션에 바로 넣으니 뭘 하는진 모르겠지만 컴파일이 오래 걸린다.
        // 해서 secondsRaw 변수로 분리했다.

        let secondsRaw = 3*60*60 + 45*60 + 15 // 3:45:15
        let seconds = Duration.seconds(secondsRaw)

        #expect(seconds.formatted(.units(allowed: [.hours, .minutes, .seconds])) == "3시간 45분 15초" )
    }

    @Test func testHourMinute() throws {
        var style = Duration.UnitsFormatStyle(
            allowedUnits: [.hours, .minutes],
            width: .wide
        )
        style.locale = Locale(identifier: "en_US")

        let secondsRaw = 3*60*60 + 45*60 + 15 // 3:45:15
        let seconds = Duration.seconds(secondsRaw)

        #expect(seconds.formatted(style) == "3 hours, 45 minutes")
    }

    @Test func testHourMinuteWithRoundSeconds() throws {
        var style = Duration.UnitsFormatStyle(
            allowedUnits: [.hours, .minutes],
            width: .wide,
            fractionalPart: .hide(rounded: .up)
        )
        style.locale = Locale(identifier: "en_US")

        let secondsRaw = 3*60*60 + 45*60 + 15 // 3:45:15
        let seconds = Duration.seconds(secondsRaw)

        #expect(seconds.formatted(style) == "3 hours, 46 minutes")
    }

    @Test func testHourMinuteSecond() throws {
        var style = Duration.UnitsFormatStyle(
            allowedUnits: [.hours, .minutes, .seconds, .milliseconds],
            width: .abbreviated
        )
        style.locale = Locale(identifier: "en_US")

        let millisRaw = (3*60*60 + 45*60 + 15)*1000 + 777 // 3:45:15.777
        let millis = Duration.milliseconds(millisRaw)

        #expect(millis.formatted(style) == "3 hr, 45 min, 15 sec, 777 ms")
    }

    @Test func testMinuteSecond() throws {
        var style = Duration.UnitsFormatStyle(
            allowedUnits: [.minutes, .seconds, .milliseconds],
            width: .abbreviated
        )
        style.locale = Locale(identifier: "en_US")

        let millisRaw = (3*60*60 + 45*60 + 15)*1000 + 777 // 3:45:15.777
        let millis = Duration.milliseconds(millisRaw)

        #expect(millis.formatted(style) == "225 min, 15 sec, 777 ms")
    }

}
