//
//  TaskGroupTesting.swift
//  HelloSwiftTests
//
//  Created by Kyuhyun Park on 11/14/24.
//

import Foundation
import Testing

// https://developer.apple.com/documentation/swift/taskgroup

// The async-let syntax implicitly creates a child task
// Tasks are arranged in a hierarchy. ...
// this approach is called structured concurrency.

fileprivate func identityAsync(_ number: Int) async -> Int {
    return number
}

struct TaskGroupTesting {

    @Test func testAsyncLet() async throws {
        async let first = identityAsync(10)
        async let second = identityAsync(20)
        async let third = identityAsync(30)

        let numbers = await [first, second, third]

        #expect(numbers == [10, 20, 30])
    }

    @Test func testTaskGroup() async throws {

        // group 을 만들려면 아래 함수들을 용도에 맞게 쓴다.
        // withTaskGroup,
        // withThrowingTaskGroup,
        // withDiscardingTaskGroup,
        // withThrowingDiscardingTaskGroup

        let sum = await withTaskGroup(of: Int.self) { group in

            // addTask 는 group 이 캔슬되었는지 확인하지 않는다.
            // 확인하고 add 하려면 addTaskUnlessCancelled(priority:body:) 을 사용한다.

            group.addTask {
                await identityAsync(10)
            }
            group.addTask {
                await identityAsync(20)
            }
            group.addTask {
                await identityAsync(30)
            }

            var sum = 0
            for await number in group {
                sum += number
            }
            return sum
        }

        #expect(sum == 60)
    }

    @Test func testTaskGroupReduce() async throws {

        let sum = await withTaskGroup(of: Int.self) { group in
            group.addTask {
                await identityAsync(10)
            }
            group.addTask {
                await identityAsync(20)
            }
            group.addTask {
                await identityAsync(30)
            }

            return await group.reduce(0) { $0 + $1 }
        }

        #expect(sum == 60)
    }

    @Test func testCancelled() async throws {

        let lastNumber = await withTaskGroup(of: Int?.self) { group in
            var lastNumber = 0
            for number in [10, 20, 30, 40, 50] {
                lastNumber = number
                guard !group.isCancelled else { break }
                group.addTask {
                    guard !Task.isCancelled else { return nil }
                    return await identityAsync(number)
                }
                if number == 20 {
                    group.cancelAll()
                }
            }

            return lastNumber
        }

        #expect(lastNumber == 30)
    }

}
