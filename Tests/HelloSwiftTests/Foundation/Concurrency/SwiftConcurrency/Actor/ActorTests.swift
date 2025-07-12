//
//  ActorTests.swift
//  HelloSwiftTests
//
//  Created by Kyuhyun Park on 11/11/24.
//

import Foundation
import Testing

// https://docs.swift.org/swift-book/documentation/the-swift-programming-language/concurrency#Actors
// https://developer.apple.com/documentation/swift/actor

// Task 간 뭔가 공유하고 싶을 때 사용한다.

// actors are reference types.
// only one task to access actor's mutable state at a time.

struct ActorTests {

    actor Counter {
        var value = 0

        func increment() {
            value += 1
        }

        func increment2() {
            self.increment() // 내부에서 다른 메서드 호출할 때는 await 이 필요없다.
        }

        func getValue() -> Int {
            value
        }
    }

    @Test func testActor() throws {
        let counter = Counter()
        _ = counter

        // counter.value 에러남
        // counter.increment() 에러남
    }

    @Test func testActorInAsyncFunc() async throws {
        let counter = Counter()

        #expect((await counter.value) == 0)

        // 외부에서 actor 메서드 쓰려면 await 걸어야 한다.
        await counter.increment()

        #expect((await counter.value) == 1)
        #expect((await counter.getValue()) == 1)
    }

}
