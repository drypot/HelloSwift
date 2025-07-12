//
//  EmptyTests.swift
//  HelloSwiftTests
//
//  Created by Kyuhyun Park on 12/2/24.
//

import Foundation
import Combine
import HelloSwift
import Testing

struct EmptyTests {

    @Test func testEmpty() throws {
        let logger = SimpleLogger<Int>()
        var cancellables = Set<AnyCancellable>()

        Empty()
            .sink { value in
                logger.log(value)
            }
            .store(in: &cancellables)

        #expect(logger.result() == [])
    }

}
