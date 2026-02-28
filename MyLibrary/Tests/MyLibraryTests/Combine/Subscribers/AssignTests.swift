//
//  AssignTests.swift
//  HelloSwiftTests
//
//  Created by Kyuhyun Park on 12/2/24.
//

import Foundation
import Combine
import MyLibrary
import Testing

// https://developer.apple.com/documentation/combine

struct AssignTests {

    @Test func testAssign() throws {
        var cancellables = Set<AnyCancellable>()

        class Receiver {
            let logger = SimpleLogger<Int>()
            var value: Int {
                get { 0 }
                set {
                    logger.log(newValue)
                }
            }
        }

        let receiver = Receiver()

        [1, 2, 3, 4, 5].publisher
            .assign(to: \.value, on: receiver)
            .store(in: &cancellables)

        receiver.logger.log(99)

        #expect(receiver.logger.result() == [1, 2, 3, 4, 5, 99])
    }

}
