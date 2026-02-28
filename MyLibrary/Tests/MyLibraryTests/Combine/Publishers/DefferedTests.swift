//
//  DefferedTests.swift
//  HelloSwiftTests
//
//  Created by Kyuhyun Park on 12/2/24.
//

import Foundation
import Combine
import MyLibrary
import Testing

struct DefferedTests {

    @Test func testDeffered() throws {
        let logger = SimpleLogger<Int>()
        var cancellables = Set<AnyCancellable>()

        // Subscriber 가 붙으면 Publisher 를 생성한다.

        Deferred {
            return Just(42)
        }
        .sink { value in
            logger.log(value)
        }
        .store(in: &cancellables)

        #expect(logger.result() == [42])
    }

}
