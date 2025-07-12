//
//  OSAllocatedUnfairLockTests.swift
//  HelloSwiftTests
//
//  Created by Kyuhyun Park on 11/28/24.
//

import Foundation
import os
import Testing

struct OSAllocatedUnfairLockTests {

    @Test func testOSAllocatedUnfairLock() throws {

        // OSAllocatedUnfairLock 은 value type 이라 다른 스레드로 복제할 수 있다.
        // 하지만 복제된 모든 OSAllocatedUnfairLock 은 하나의 lock 을 사용한다.

        let lockable = OSAllocatedUnfairLock<Int>(initialState: 0)

        DispatchQueue.concurrentPerform(iterations: 10) { _ in
            lockable.withLock { $0 += 1 }
        }

        let snapshot = lockable.withLock { $0 }

        #expect(snapshot == 10)
    }

    @Test func testWithClass() throws {

        // 여러 스레드에서 공유하려면 class 여야 한다.
        // Sendable 해야 다른 스레드에서 실행될 클로저에 넣을 수 있다.
        // final class 여야 Sendable 해 진다.

        final class Counter: Sendable {
            let _value: OSAllocatedUnfairLock<Int>

            init() {
                _value = OSAllocatedUnfairLock<Int>(initialState: 0)
            }

            func increment() {
                _value.withLock { value in
                    value += 1
                }
            }

            func value() -> Int {
                return _value.withLock { $0 }
            }
        }

        let counter = Counter()

        DispatchQueue.concurrentPerform(iterations: 10) { _ in
            counter.increment()
        }

        #expect(counter.value() == 10)
    }

}
