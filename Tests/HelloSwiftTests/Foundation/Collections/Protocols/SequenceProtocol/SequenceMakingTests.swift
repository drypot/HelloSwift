//
//  SequenceMakingTests.swift
//  HelloSwiftTests
//
//  Created by Kyuhyun Park on 11/4/24.
//

import Foundation
import Testing

// protocol Sequence<Element>
// A type that provides sequential, iterated access to its elements.
// https://github.com/swiftlang/swift/blob/main/stdlib/public/core/Sequence.swift

struct SequenceMakingTests {

    struct Counter: Sequence {
        typealias Element = Int

        let limit: Element

        func makeIterator() -> Iterator {
            return Iterator(limit: limit)
        }

        struct Iterator: IteratorProtocol {
            let limit: Element
            var current = 0

            mutating func next() -> Element? {
                guard current < limit else { return nil }
                defer { current += 1 }
                return current
            }
        }
    }

    // Sequence, IteratorProtocol 를 동일 struct 에 구현할 수도 있다.
    //
    // makeIterator() 는 default 구현에서 온다.
    // 그냥 self 를 리턴하는데 struct 라 복제본이 넘어오는 개념일 듯.
    // makeIterator() 명시적으로 적어 놓는 것도 나쁘지 않은 것 같다.

    struct CounterCompact: Sequence, IteratorProtocol {
        typealias Element = Int

        let limit: Element
        var current = 0

        func makeIterator() -> Self {
            return self
        }

        mutating func next() -> Element? {
            guard current < limit else { return nil }
            defer { current += 1 }
            return current
        }
    }

    @Test func testCounter() throws {
        let counter = Counter(limit: 3)
        var iterator = counter.makeIterator()

        #expect(iterator.next() == 0)
        #expect(iterator.next() == 1)
        #expect(iterator.next() == 2)
        #expect(iterator.next() == nil)
    }

    @Test func testCounterWithFor() throws {
        let counter = Counter(limit: 3)
        var result = [Int]()

        for count in counter {
            result.append(count)
        }

        #expect(result == [0, 1, 2])
    }

    @Test func testCounterCompact() throws {
        let counter = CounterCompact(limit: 3)
        var iterator = counter.makeIterator()

        #expect(iterator.next() == 0)
        #expect(iterator.next() == 1)
        #expect(iterator.next() == 2)
        #expect(iterator.next() == nil)
    }

    @Test func testClosureCounter() throws {
        func makeCounter(limit: Int) -> AnyIterator<Int> {
            var current = 0
            return AnyIterator {
                guard current < limit else { return nil }
                defer { current += 1 }
                return current
            }
        }

        let counter = makeCounter(limit: 3)
        let iterator = counter.makeIterator()

        #expect(iterator.next() == 0)
        #expect(iterator.next() == 1)
        #expect(iterator.next() == 2)
        #expect(iterator.next() == nil)
    }
}
