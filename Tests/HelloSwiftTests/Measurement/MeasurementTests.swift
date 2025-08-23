//
//  MeasurementTests.swift
//  HelloSwiftTests
//
//  Created by Kyuhyun Park on 10/29/24.
//

import Foundation
import Testing

// https://developer.apple.com/documentation/foundation/measurement
// https://developer.apple.com/documentation/foundation/unit
// https://developer.apple.com/documentation/foundation/dimension

struct MeasurementTests {

    @Test func testUnitDuration() throws {
        let m1 = Measurement<UnitDuration>(value: 90, unit: .seconds)
        let m2 = m1.converted(to: .minutes)

        #expect(m1.value == 90)
        #expect(m1.unit == .seconds)

        #expect(m2.value == 1.5)
        #expect(m2.unit == .minutes)

        #expect(m1 == m2)
    }

    @Test func testArithmetic() throws {
        let m1 = Measurement<UnitDuration>(value: 90, unit: .seconds)
        let m2 = Measurement<UnitDuration>(value: 1, unit: .minutes)

        let sum = m1 + m2
        let diff = m1 - m2

        #expect(sum == Measurement(value: 150, unit: .seconds))
        #expect(diff == Measurement(value: 30, unit: .seconds))
    }

}
