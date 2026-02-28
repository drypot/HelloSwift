//
//  ContinuationTests.swift
//  HelloSwiftTests
//
//  Created by Kyuhyun Park on 11/16/24.
//

import Foundation
import MyLibrary
import Testing

// https://developer.apple.com/documentation/swift/withcheckedcontinuation(isolation:function:_:)

// Testing completion handler based code in Swift Testing
// https://www.donnywals.com/testing-completion-handler-based-code-in-swift-testing/

struct ContinuationTests {

    // callback 받는 구형 API 가 있을 때, 이를 async/await 코드로 감쌀 수 있다.

    @Test func testContinuation() async throws {
        let logger = SimpleLogger<Int>()

        logger.log(1)
        do {
            let result = try await withCheckedThrowingContinuation {
                (continuation: CheckedContinuation<String, Error>) in
                logger.log(2)
                DispatchQueue.global().async {
                    logger.log(3)
                    continuation.resume(returning: "hello")
                    logger.log(4)
                }
                logger.log(5)
            }
            logger.log(6)
            #expect(result == "hello")
        } catch let error as NSError {
            logger.log(7)
            _ = error
        }

        #expect(logger.result() == [1, 2, 5, 3, 4, 6])
    }

    @Test func testThrowingContinuation() async throws {
        let logger = SimpleLogger<Int>()

        logger.log(1)
        do {
            let _ = try await withCheckedThrowingContinuation {
                (continuation: CheckedContinuation<String, Error>) in
                logger.log(2)
                DispatchQueue.global().async {
                    logger.log(3)
                    let error = NSError(domain: "Test", code: 100, userInfo: nil)
                    continuation.resume(throwing: error)
                    logger.log(4)
                }
                logger.log(5)
            }
            logger.log(6)
        } catch let error as NSError {
            logger.log(7)
            #expect(error.code == 100)
        }

        #expect(logger.result() == [1, 2, 5, 3, 4, 7])
    }


}
