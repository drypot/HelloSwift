//
//  FailTests.swift
//  HelloSwiftTests
//
//  Created by Kyuhyun Park on 12/2/24.
//

import Foundation
import Combine
import MyLibrary
import Testing

struct FailTests {

    @Test func testFail() throws {
        let logger = SimpleLogger<Int>()
        var cancellables = Set<AnyCancellable>()

        enum CustomError: Error {
            case someError
        }

        Fail(outputType: Int.self, failure: CustomError.someError)
            .sink { completion in
                switch completion {
                case .finished:
                    logger.log(1)
                case .failure:
                    logger.log(2)
                }
            } receiveValue: { _ in
                logger.log(3)
            }
            .store(in: &cancellables)

        #expect(logger.result() == [2])
    }

}
