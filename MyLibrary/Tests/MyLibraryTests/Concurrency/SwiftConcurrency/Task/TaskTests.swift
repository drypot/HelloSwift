//
//  TaskTests.swift
//  Tests
//
//  Created by Kyuhyun Park on 6/5/24.
//

import MyLibrary
import Testing

// https://docs.swift.org/swift-book/documentation/the-swift-programming-language/concurrency#Tasks-and-Task-Groups
// https://developer.apple.com/documentation/swift/task

struct TaskTests {

    @Test func testTask() async throws {

        // TaskGroup 을 사용해서 명시적으로 Task 트리 짜는 것을 structured concurrency 라고 부른다.
        // 아래 처럼 TaskGroup 없이 단독 Task 생성해 쓰는 것을 unstructured task 라고 부른다.
        // Task 는 caller 의 actor context 를 계승한다.

        let value = await Task {
            return "done"
        }.value

        #expect(value == "done")
    }

    @Test func testAwaitDetachedTaskValue() async throws {

        // actor context 를 계승하지 않으려면 detached task 를 만든다.

        let value = await Task.detached {
            return "done"
        }.value

        #expect(value == "done")
    }

    @Test func testAwaitTaskResult() async throws {
        let result = await Task {
            return "done"
        }.result

        #expect(result == .success("done"))
    }

    @Test func testCancelled() async throws {
        let task = Task {
            if Task.isCancelled {
                return "cancelled"
            } else {
                return "done"
            }
        }

        task.cancel()
        let value = await task.value

        #expect(value == "cancelled")
    }

    @Test func testCheckCancellation() async throws {
        do {
            let task = Task<String, Error> {
                try Task.checkCancellation()
                return "done"
            }

            task.cancel()
            let _ = try await task.value

            fatalError()
        } catch {
            #expect(error is CancellationError)
        }
    }

    @Test func testCheckCancellationResult() async throws {
        let task = Task<String, Error> {
            try Task.checkCancellation()
            return "done"
        }

        task.cancel()
        let result = await task.result

        switch result {
        case .success:
            fatalError()
        case .failure(let error):
            #expect(error is CancellationError)
        }
    }

    @Test func testTaskYield() async throws {
        let logger = SimpleLogger<Int>()

        let task1 = Task {
            for _ in 0..<2 {
                logger.log(1)
                await Task.yield()
            }
        }

        let task2 = Task {
            for _ in 0..<2 {
                logger.log(2)
                await Task.yield()
            }
        }

        await task1.value
        await task2.value

        #expect(logger.result() == [1, 2, 1, 2])
    }

    @Test func testTaskSleep() async throws {
        try await Task.sleep(for: .milliseconds(10))
    }

}
