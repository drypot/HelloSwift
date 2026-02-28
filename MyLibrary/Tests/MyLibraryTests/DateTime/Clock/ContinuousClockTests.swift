//
//  ContinuousClockTests.swift
//  HelloSwiftTests
//
//  Created by Kyuhyun Park on 11/15/24.
//

import Foundation
import Testing

// https://developer.apple.com/documentation/swift/continuousclock
// A Stopwatch style time.

struct ContinuousClockTests {

    @Test func testSleep() async throws {
        let time1 = ContinuousClock.now

        try await ContinuousClock().sleep(for: .milliseconds(50))

        let time2 = ContinuousClock.now

        #expect(time2 - time1 >= .milliseconds(50))
    }

    @Test func test() async throws {
        let duration = try await ContinuousClock().measure {
            try await ContinuousClock().sleep(for: .milliseconds(50))
        }

        #expect(duration >= .milliseconds(50))

        // print(duration.formatted(.units(allowed: [.milliseconds])))
    }

}
