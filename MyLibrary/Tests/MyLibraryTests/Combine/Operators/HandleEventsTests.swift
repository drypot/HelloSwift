//
//  HandleEventsTests.swift
//  HelloSwift
//
//  Created by Kyuhyun Park on 12/16/24.
//

import Foundation
import Combine
import MyLibrary
import Testing

// https://developer.apple.com/documentation/combine

struct HandleEventsTests {

    @Test func test() throws {
        let logger = SimpleLogger<String>()
        var cancellables = Set<AnyCancellable>()

        Just("value")
            .handleEvents(receiveSubscription: { _ in
                logger.log("receiveSubscription")
            }, receiveOutput: { _ in
                logger.log("receiveOutput")
            }, receiveCompletion: { _ in
                logger.log("receiveCompletion")
            }, receiveCancel: {
                logger.log("receiveCancel")
            }, receiveRequest: { _ in
                logger.log("receiveRequest")
            })
            .sink { completion in
                logger.log("sink completion")
            } receiveValue: { value in
                logger.log("sink value")
            }
            .store(in: &cancellables)

        logger.log("end")

        #expect(logger.result() == [
            "receiveSubscription",
            "receiveRequest",
            "receiveOutput",
            "sink value",
            "receiveCompletion",
            "sink completion",
            "end"
        ])
    }

}
