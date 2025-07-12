//
//  AsyncSequenceTests.swift
//  HelloSwiftTests
//
//  Created by Kyuhyun Park on 11/11/24.
//

import Foundation
import Testing

// https://developer.apple.com/documentation/swift/asyncsequence

struct AsyncSequenceTests {

    struct AsyncCounter: AsyncSequence {
        typealias Element = Int

        let limit: Element

        func makeAsyncIterator() -> AsyncIterator {
            return AsyncIterator(limit: limit)
        }

        struct AsyncIterator: AsyncIteratorProtocol {
            let limit: Element
            var current = 0

            mutating func next() async -> Element? {
                guard current < limit else { return nil }
                defer { current += 1 }
                return current
            }
        }
    }

    struct AsyncCounterCompact: AsyncSequence, AsyncIteratorProtocol {
        typealias Element = Int

        let limit: Element
        var current = 0

        func makeAsyncIterator() -> Self {
            return self
        }

        mutating func next() async -> Element? {
            guard current < limit else { return nil }
            defer { current += 1 }
            return current
        }
    }

    @Test func testAsyncCounter() async throws {
        let counter = AsyncCounter(limit: 3)
        var iterator = counter.makeAsyncIterator()

        #expect((await iterator.next()) == 0)
        #expect((await iterator.next()) == 1)
        #expect((await iterator.next()) == 2)
        #expect((await iterator.next()) == nil)
    }

    @Test func testAsyncCounterWithFor() async throws {
        let counter = AsyncCounter(limit: 3)
        var result = [Int]()

        for await count in counter {
            result.append(count)
        }

        #expect(result == [0, 1, 2])
    }

    @Test func testAsyncCounterCompact() async throws {
        let counter = AsyncCounterCompact(limit: 3)
        var iterator = counter.makeAsyncIterator()

        #expect((await iterator.next()) == 0)
        #expect((await iterator.next()) == 1)
        #expect((await iterator.next()) == 2)
        #expect((await iterator.next()) == nil)
    }
    
}
