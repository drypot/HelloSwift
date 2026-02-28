//
//  DurationTests.swift
//  HelloSwiftTests
//
//  Created by Kyuhyun Park on 10/31/24.
//

import Foundation
import Testing

// TimeInterval: Double, 단위는 seconds, 주로 date and time 연산에 사용,

// Duration: Swift struct, 단위는 seconds, milliseconds, nanoseconds 변동, 주로 Swift Concurrency 에 사용,

struct DurationTests {

    @Test func testTimeInterval() throws {
        let interval: TimeInterval = 60.0  // 60 seconds
        let futureDate = Date(timeIntervalSinceReferenceDate: 30).addingTimeInterval(interval)

        #expect(futureDate == Date(timeIntervalSinceReferenceDate: 90))
    }

    @Test func testDuration() throws {
        let seconds = Duration.seconds(55)
        let milliseconds = Duration.milliseconds(66)
        let microseconds = Duration.microseconds(77)
        let nanoseconds = Duration.nanoseconds(88)

        let sum = seconds + milliseconds + microseconds + nanoseconds

        // Duration 만들 때 Double 이나 BinaryInteger 를 쓸 수 있다.
        // Double 을 써서 소숫점 아래 수치들을 사용하면 오차가 발생한다.
        #expect(sum != Duration.seconds(55.066_077_088))
        #expect(sum < Duration.seconds(55.066_077_088))

        // 단위를 내려서 정수로 표현하면 오차가 사라진다.
        #expect(sum == Duration.nanoseconds(55_066_077_088))

        #expect(Duration.seconds(0.100) == Duration.milliseconds(100))
        #expect(Duration.seconds(0.444) == Duration.milliseconds(444))
        #expect(Duration.seconds(0.555) != Duration.milliseconds(555)) // 다르다고 나온다.
        #expect(Duration.seconds(0.666) == Duration.milliseconds(666))
    }

}
