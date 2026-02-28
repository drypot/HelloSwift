//
//  JustTests.swift
//  HelloSwiftTests
//
//  Created by Kyuhyun Park on 12/2/24.
//

import Foundation
import Combine
import MyLibrary
import Testing

struct JustTests {

    @Test func testJust() throws {
        let logger = SimpleLogger<Int>()
        var cancellables = Set<AnyCancellable>()

        // 값 하나를 출력한다.

        Just(42)
            .sink { value in
                logger.log(value)
            }
            .store(in: &cancellables)

        #expect(logger.result() == [42])
    }

}
