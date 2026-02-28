//
//  SequenceLazyTests.swift
//  HelloSwiftTests
//
//  Created by Kyuhyun Park on 11/6/24.
//

import Foundation
import Testing

struct SequenceLazyTests {

    @Test func testLazy() throws {
        // 일반 Sequence 의 filter, map 등은 어레이를 리턴한다.
        // LazySequence 의 map 은 LazyMapSequence 를 리턴한다.
        // LazySequence 는 다음 아이템 요청이 들어올 때마다 Base Sequence 를 참조해 연산을 한다.

        let largeArray = Array(1...10)

        let lazy = largeArray.lazy
        let lazyfiltered = lazy.filter { $0 % 2 == 0 }  // 2, 4, 6, 8, 10
        let lazyFilteredMapped = lazyfiltered.map { $0 * $0 }  // 4, 16, 36, 64, 100

        var result = [Int]()

        for value in lazyFilteredMapped {
            result.append(value)
        }

        #expect(result == [4, 16, 36, 64, 100])
    }

    @Test func testLazyStepByStep() throws {

        struct Log {
            nonisolated(unsafe) static var log = [String]()
        }

        struct Base: Sequence {
            let limit: Int

            func makeIterator() -> BaseIterator {
                BaseIterator(limit: limit)
            }
        }

        struct BaseIterator: IteratorProtocol {
            let limit: Int
            var current = 0

            mutating func next() -> Int? {
                guard current < limit else { return nil }
                Log.log.append("base \(current)")
                defer { current += 1 }
                return current
            }
        }

        let seq = Base(limit: 10).lazy
            .filter {
                Log.log.append("filtering \($0)")
                return $0 % 2 == 0
            }
            .map {
                Log.log.append("mapping \($0)")
                return $0 * $0
            }

        for value in seq {
            Log.log.append("consuming \(value)")
        }

        #expect(Log.log == [
            "base 0", "filtering 0", "mapping 0", "consuming 0",
            "base 1", "filtering 1",
            "base 2", "filtering 2", "mapping 2", "consuming 4",
            "base 3", "filtering 3",
            "base 4", "filtering 4", "mapping 4", "consuming 16",
            "base 5", "filtering 5",
            "base 6", "filtering 6", "mapping 6", "consuming 36",
            "base 7", "filtering 7",
            "base 8", "filtering 8", "mapping 8", "consuming 64",
            "base 9", "filtering 9"
        ])
    }
}
