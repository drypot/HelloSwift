//
//  ActorLoggerTests.swift
//  HelloSwiftTests
//
//  Created by Kyuhyun Park on 11/20/24.
//

import Foundation
import Testing
import HelloSwift

struct ActorLoggerTests {

    @Test func test() async throws {
        let logger = ActorLogger()

        await logger.append("abc")
        await logger.append("123")

        let log = await logger.log()

        #expect(log == ["abc", "123"])
    }

    @Test func testWithTask() async throws {
        let logger = ActorLogger()

        await logger.append("abc")
        await Task {
            await logger.append("123")
        }.value

        let log = await logger.log()

        #expect(log == ["abc", "123"])

    }

}
