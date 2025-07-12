//
//  MeasurementFormatTests.swift
//  HelloSwiftTests
//
//  Created by Kyuhyun Park on 10/29/24.
//

import Foundation
import Testing

// Data Formatting
// https://developer.apple.com/documentation/foundation/data_formatting

// Measurement
// https://developer.apple.com/documentation/foundation/measurement
// struct Measurement<UnitType> where UnitType : Unit

// Unit: NSObject
// https://developer.apple.com/documentation/foundation/unit

// https://developer.apple.com/documentation/foundation/measurement/formatstyle
// https://developer.apple.com/documentation/foundation/measurement/formatstyle/unitwidth

// https://developer.apple.com/documentation/foundation/measurement/formatstyle/3816386-usage
// https://developer.apple.com/documentation/foundation/measurementformatunitusage

// measurement(width:usage:numberFormatStyle:)
// measurement(width:usage:hidesScaleName:numberFormatStyle:)
// https://developer.apple.com/documentation/foundation/measurement/formatstyle/3870187-measurement
// Returns a format style to format measurement units.

struct MeasurementFormatTests {

    @Test func testUnitDuration() throws {

        // https://developer.apple.com/documentation/foundation/unitduration
        // UnitDuration: A unit of measure for a duration of time.

        let m1 = Measurement<UnitDuration>(value: 90, unit: .seconds)

        #expect(m1.formatted(.measurement(width: .abbreviated)) == "90초")

        var style = Measurement<UnitDuration>.FormatStyle(
            width: .abbreviated,
            locale: Locale(identifier: "en_US")
        )

        #expect(m1.formatted(style) == "90 sec")

        style.width = .wide
        #expect(m1.formatted(style) == "90 seconds")

        style.width = .narrow
        #expect(m1.formatted(style) == "90s")
    }

    @Test func testUnitLengthPersonHeight() throws {

        // https://developer.apple.com/documentation/foundation/unitlength
        // UnitLength: A unit of measure for length.

        let m1 = Measurement<UnitLength>(value: 173, unit: .centimeters)

        #expect(m1.formatted(.measurement(width: .abbreviated)) == "1.7m")
        #expect(m1.formatted(.measurement(width: .abbreviated, usage: .personHeight)) == "173cm")

        var style = Measurement<UnitLength>.FormatStyle(
            width: .abbreviated,
            locale: Locale(identifier: "ko_KR"),
            usage: .personHeight
        )

        #expect(m1.formatted(style) == "173cm")

        style.width = .wide
        #expect(m1.formatted(style) == "173센티미터")

        style.width = .narrow
        #expect(m1.formatted(style) == "173cm")
    }

    @Test func testByteCount() throws {

        // Measurement.FormatStyle.ByteCount 기닌까
        // 보통은 ByteCountFormatStyle 을 사용하면 되겠다.

        let m1 = Measurement<UnitInformationStorage>(value: 128, unit: .megabytes)

        #expect(m1.formatted(.measurement(width: .abbreviated)) == "128MB")

        var style = Measurement<UnitInformationStorage>.FormatStyle.ByteCount(
            style: .memory,
            allowedUnits: .all,
            spellsOutZero: true,
            includesActualByteCount: true,
            locale: Locale(identifier: "en_US")
        )

        #expect(m1.formatted(style) == "122.1 MB (128,000,000 bytes)")

        style.includesActualByteCount = false
        #expect(m1.formatted(style) == "122.1 MB")

        style.style = .file
        #expect(m1.formatted(style) == "128 MB")

        style.allowedUnits = .kb
        #expect(m1.formatted(style) == "128,000 kB")
    }

}
