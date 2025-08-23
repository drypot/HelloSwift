//
//  AsyncStreamTests.swift
//  HelloSwiftTests
//
//  Created by Kyuhyun Park on 11/16/24.
//

import Foundation
import Testing

// https://developer.apple.com/documentation/swift/asyncstream

// AsyncStream conforms to AsyncSequence,
// AsyncStream 은 asynchronous sequence 간편하게 만들고 싶을 때 사용한다.
// AsyncStream 을 쓰면 asynchronous iterator 구현할 필요가 없어진다.

struct AsyncStreamTests {

    @Test func test() async throws {
        let stream = AsyncStream { continuation in
            continuation.yield(10)
            continuation.yield(20)
            Task {
                continuation.yield(30)
                continuation.finish()
            }
        }

        var iterator = stream.makeAsyncIterator()

        #expect((await iterator.next()) == 10)
        #expect((await iterator.next()) == 20)
        #expect((await iterator.next()) == 30)
        #expect((await iterator.next()) == nil)
    }

}
