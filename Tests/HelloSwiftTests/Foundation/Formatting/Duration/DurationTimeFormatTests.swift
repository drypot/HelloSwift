//
//  DurationTimeFormatTests.swift
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

// Duration.TimeFormatStyle
// https://developer.apple.com/documentation/swift/duration/timeformatstyle

// Duration.TimeFormatStyle.Pattern
// https://developer.apple.com/documentation/swift/duration/timeformatstyle/pattern-swift.struct

struct DurationTimeFormatTests {

    @Test func testFactory() throws {

        // https://developer.apple.com/documentation/foundation/formatstyle/3988407-time
        // time(pattern:) : Returns a style for formatting a duration using a provided pattern.

        // 수식을 펑션에 바로 넣으니 뭘 하는진 모르겠지만 컴파일이 오래 걸린다.
        // 해서 secondsRaw 변수로 분리했다.

        let secondsRaw = 3*60*60 + 45*60 + 15 // 3:45:15
        let seconds = Duration.seconds(secondsRaw)

        #expect(seconds.formatted(.time(pattern: .hourMinute)) == "3:45")
        #expect(seconds.formatted(.time(pattern: .hourMinuteSecond)) == "3:45:15")
        #expect(seconds.formatted(.time(pattern: .minuteSecond)) == "225:15")
    }

    @Test func testHourMinute() throws {
        let style = Duration.TimeFormatStyle(
            pattern: .hourMinute(padHourToLength: 2),
            locale: Locale(identifier: "ko_KR")
        )

        let secondsRaw = 3*60*60 + 45*60 + 15 // 3:45:15
        let seconds = Duration.seconds(secondsRaw)

        #expect(seconds.formatted(style) == "03:45")
    }

    @Test func testHourMinuteWithRoundSeconds() throws {
        let style = Duration.TimeFormatStyle(
            pattern: .hourMinute(padHourToLength: 2, roundSeconds: .up),
            locale: Locale(identifier: "ko_KR")
        )

        let secondsRaw = 3*60*60 + 45*60 + 15 // 3:45:15
        let seconds = Duration.seconds(secondsRaw)

        #expect(seconds.formatted(style) == "03:46")
    }

    @Test func testHourMinuteSecond() throws {
        let style = Duration.TimeFormatStyle(
            pattern: .hourMinuteSecond(padHourToLength: 2, fractionalSecondsLength: 3),
            locale: Locale(identifier: "ko_KR")
        )

        // 수식을 펑션에 바로 넣으니 뭘 하는진 모르겠지만 컴파일이 오래 걸린다.
        // 해서 secondsRaw 변수로 분리했다.

        let millisRaw = (3*60*60 + 45*60 + 15)*1000 + 777 // 3:45:15.777
        let millis = Duration.milliseconds(millisRaw)

        #expect(millis.formatted(style) == "03:45:15.777")
    }

    @Test func testMinuteSecond() throws {
        let style = Duration.TimeFormatStyle(
            pattern: .minuteSecond(padMinuteToLength: 0, fractionalSecondsLength: 3),
            locale: Locale(identifier: "ko_KR")
        )

        let millisRaw = (3*60*60 + 45*60 + 15)*1000 + 777 // 3:45:15.777
        let millis = Duration.milliseconds(millisRaw)

        #expect(millis.formatted(style) == "225:15.777")
    }

}
