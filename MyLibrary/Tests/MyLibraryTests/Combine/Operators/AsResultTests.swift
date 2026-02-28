//
//  AsResultTests.swift
//  HelloSwiftTests
//
//  Created by Kyuhyun Park on 4/28/25.
//

import Foundation
import Combine
import MyLibrary
import Testing

struct AsResultTests {

    @Test func testSuccess() throws {
        let logger = SimpleLogger<String>()
        var cancellables = Set<AnyCancellable>()

        Just(10)
            .asResult()
            .sink { result in
                switch result {
                case .success(let value):
                    logger.log("success: \(value)")
                case .failure:
                    logger.log("failed")
                }
            }
            .store(in: &cancellables)

        #expect(logger.result() == [
            "success: 10"
        ])
    }

    @Test func testFailure() throws {
        let logger = SimpleLogger<String>()
        var cancellables = Set<AnyCancellable>()

        enum MyError: Error {
            case somethingWentWrong
        }

        Fail<Int, MyError>(error: .somethingWentWrong)
            .asResult()
            .sink { result in
                switch result {
                case .success(let value):
                    logger.log("success: \(value)")
                case .failure:
                    logger.log("failed")
                }
            }
            .store(in: &cancellables)

        #expect(logger.result() == [
            "failed"
        ])
    }

}
