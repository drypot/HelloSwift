//
//  DispatchQueueTests.swift
//  HelloSwiftTests
//
//  Created by Kyuhyun Park on 11/28/24.
//

import Foundation
import Testing
import HelloSwift

// https://developer.apple.com/documentation/dispatch
// https://developer.apple.com/library/archive/documentation/General/Conceptual/ConcurrencyProgrammingGuide/Introduction/Introduction.html#//apple_ref/doc/uid/TP40008091-CH1-SW1

// Dispatch, also known as Grand Central Dispatch (GCD), ...

// 옛날 기술들이지만, 그래도 한번 정리하고 가야할 것 같아서,

struct DispatchQueueTests {

    @Test func testSerialQueue() throws {
        let logger = SimpleLogger<Int>()

        // DispatchQueue.main 은 Serial Queue 이다.
        // DispatchQueue.global() 은 Concurrent Queue 이다.

        // 특별한 옵션 없이 큐를 생성하면 Serial Queue 가 만들어 진다.

        let queue = DispatchQueue(label: "com.example.serialQueue")
        let group = DispatchGroup()

        group.enter()
        queue.async {
            logger.log(1)
            group.leave()
        }

        group.enter()
        queue.async {
            logger.log(2)
            group.leave()
        }

        group.enter()
        DispatchQueue.global().async {
            logger.log(3)
            group.leave()
        }

        // DispatchQueue 실행 완료를 기다리는데 몇 가지 방법들이 있는데
        // DispatchGroup 쓰는 것이 그나마 무난해 보인다.

        // DispatchGroup 은 큐와 상관없이 그냥 자기 혼자 카운팅만 하고 있는 것 같다.
        // wait() 하면 group.leave() 가 모두 실행될 때까지 기다린다.

        group.wait()

        #expect(logger.result() == [1, 2, 3])
    }

    @Test func testCallMainQueue() throws {
        let logger = SimpleLogger<Int>()

        let group = DispatchGroup()

        group.enter()
        DispatchQueue.global().async {

            // global 큐에서 실행된 결과를 main 큐에 반영하려면
            // global 큐 안에서 main.async 를 부른다고 한다.

            DispatchQueue.main.async {
                logger.log(1)
                group.leave()
            }
        }

        group.wait()

        #expect(logger.result() == [1])
    }

    @Test func testDispatchQueueSync() async throws {

        // 리소스 접근을 DispatchQueue.sync 로 동기화할 수도 있다.

        nonisolated final class SyncObject: Sendable {
            nonisolated(unsafe) var _value = 0
            let queue = DispatchQueue(label: "com.example.testDispatchQueueSync")

            var value: Int {
                get {
                    queue.sync { _value }
                }
                set(newValue) {
                    queue.sync { _value = newValue }
                }
            }

            func increase() {
                queue.sync {
                    _value += 1
                }
            }
        }

        let syncObject = SyncObject()

        DispatchQueue.concurrentPerform(iterations: 10) { _ in
            syncObject.increase()
        }

        #expect(syncObject.value == 10)
    }

    @Test func testWorkItem() throws {
        let logger = SimpleLogger<Int>()

        let workItem = DispatchWorkItem {
            logger.log(1)
        }

        // WorkItem 을 만들어서 큐에 넣고 wait 하는 방법도 있다.
        // WorkItem 을 queue 에 넣지 않은 채로 wait 해 봤더니 행이 걸린다;
        // 꼭 넣어야 한다;

        DispatchQueue.global().async(execute: workItem)

        workItem.wait()

        #expect(logger.result() == [1])
    }

    @Test func testSemaphore() throws {
        let logger = SimpleLogger<Int>()

        let semaphore = DispatchSemaphore(value: 0)

        DispatchQueue.global().async {
            logger.log(1)
            // count 를 1 올린다.
            semaphore.signal()
        }

        // 비동기 블럭을 한 개만 실행하고 기다리는데 유용하다.
        // 아니면 공용 리소스 n 개중 남는 것이 나올 때까지 대기할 때.

        // count 0 이면 + 가 될 때까지 기다린다.
        // count + 이면 1 내리고 진행한다.
        semaphore.wait()

        #expect(logger.result() == [1])
    }

    @Test func testContinuation() async throws {
        let logger = SimpleLogger<Int>()

        await withCheckedContinuation { continuation in
            DispatchQueue.global().async {
                logger.log(1)
                continuation.resume()
            }
        }

        #expect(logger.result() == [1])
    }

}
