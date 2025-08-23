//
//  ContinuationTests.swift
//  HelloSwiftTests
//
//  Created by Kyuhyun Park on 11/16/24.
//

import Foundation
import Testing

// https://developer.apple.com/documentation/swift/withcheckedcontinuation(isolation:function:_:)

// Testing completion handler based code in Swift Testing
// https://www.donnywals.com/testing-completion-handler-based-code-in-swift-testing/

// Async 코드에 sync handler 코드를 붙일 때 사용한다.

// fetchData, fetchFailure 같은 handler 받는 구형 API 가 있을 때,

fileprivate func fetchData(completion: @escaping @Sendable (Result<String, Error>) -> Void) {
    DispatchQueue.global().async {
        completion(.success("abc"))
    }
}

fileprivate func fetchFailure(completion: @escaping @Sendable (Result<String, Error>) -> Void) {
    DispatchQueue.global().async {
        completion(.failure(NSError(domain: "FetchError", code: -1, userInfo: nil)))
    }
}

// 이를 Async 코드로 감싸려면,

struct ContinuationTests {

    @Test func testSuccess() async throws {

        let result = await withCheckedContinuation { continuation in
            fetchData { result in
                continuation.resume(returning: result)
            }
        }

        switch result {
        case .success(let data):
            #expect(data == "abc")
        case .failure:
            fatalError()
        }
    }

    @Test func testFailure() async throws {

        let result = await withCheckedContinuation { continuation in
            fetchFailure { result in
                continuation.resume(returning: result)
            }
        }

        switch result {
        case .success:
            fatalError()
        case .failure(let error as NSError):
            #expect(error.domain == "FetchError")
        }
    }

}
