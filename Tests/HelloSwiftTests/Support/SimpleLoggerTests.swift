//
//  ActorLoggerTests.swift
//  HelloSwiftTests
//
//  Created by Kyuhyun Park on 11/28/24.
//

import Foundation
import HelloSwift
import Testing

struct SimpleLoggerTests {

    @Test func testSendable() async throws {
        let logger = SimpleLogger<Int>()

        logger.log(1)

        await Task {
            logger.log(2)
        }.value

        logger.log(3)

        #expect(logger.result() == [1, 2, 3])
    }

    @Test func testLogMustBeShared() async throws {
        let logger = SimpleLogger<Int>()
        let logger2 = logger

        logger.log(1)
        logger2.log(2)

        #expect(logger.result() == [1, 2])
    }

}
