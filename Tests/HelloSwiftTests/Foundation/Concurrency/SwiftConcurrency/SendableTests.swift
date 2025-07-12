//
//  SendableTests.swift
//  HelloSwiftTests
//
//  Created by Kyuhyun Park on 11/11/24.
//

import Foundation
import Testing

// https://docs.swift.org/swift-book/documentation/the-swift-programming-language/concurrency#Sendable-Types
// https://developer.apple.com/documentation/swift/sendable
//
// https://github.com/swiftlang/swift-evolution/blob/main/proposals/0430-transferring-parameters-and-results.md

struct SendableTests {

    @Test func testSendable() async throws {

        actor Box {
            var intValue = 10

            var arrayValue = [1, 2, 3]

            actor ActorType { }
            var actorInstance = ActorType()

            final class SendableClass: Sendable { }
            var sendableInstance = SendableClass()

            final class NonisolatedClass: Sendable {
                nonisolated(unsafe) var name = "max"
            }
            var nonisolatedInstance = NonisolatedClass()

            var sendableFunction = { @Sendable in 10 }
        }

        let box = Box()

        _ = await box.intValue
        _ = await box.arrayValue
        _ = await box.actorInstance
        _ = await box.sendableInstance
        _ = await box.nonisolatedInstance
        _ = await box.sendableFunction
    }

}
