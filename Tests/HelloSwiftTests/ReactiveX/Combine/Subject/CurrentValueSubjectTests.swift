//
//  CurrentValueSubjectTests.swift
//  HelloSwift
//
//  Created by Kyuhyun Park on 12/17/24.
//

import Foundation
import Combine
import HelloSwift
import Testing

// https://developer.apple.com/documentation/combine/passthroughsubject

// provides a convenient way to adapt existing imperative code to the Combine model.

struct CurrentValueSubjectTests {

    @Test func test() throws {
        let logger = SimpleLogger<Int>()
        var cancellables = Set<AnyCancellable>()

        let subject = CurrentValueSubject<Int, Never>(10)

        subject
            .sink { completion in
                logger.log(99)
            } receiveValue: { value in
                logger.log(value)
            }
            .store(in: &cancellables)

        subject.send(1)
        subject.send(2)
        subject.value = 3
        subject.value = 4
        subject.send(completion: .finished)

        #expect(logger.result() == [10, 1, 2, 3, 4, 99])
    }

}
