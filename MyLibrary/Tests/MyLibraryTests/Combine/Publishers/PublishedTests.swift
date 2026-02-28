//
//  PublishedTests.swift
//  HelloSwiftTests
//
//  Created by Kyuhyun Park on 12/9/24.
//

import Foundation
import Combine
import MyLibrary
import Testing

struct PublishedTests {

    @Test func testPublished() throws {
        let logger = SimpleLogger<Int>()
        var cancellables = Set<AnyCancellable>()

        class Weather {
            @Published var temperature: Int

            init(temperature: Int) {
                self.temperature = temperature
            }
        }

        let weather = Weather(temperature: 10)

        weather.$temperature
            .sink {
                logger.log($0)
            }
            .store(in: &cancellables)

        weather.temperature = 20
        weather.temperature = 30
        weather.temperature = 40

        #expect(logger.result() == [10, 20, 30, 40])
    }

    @Test func testAssignToPublished() throws {
        let logger = SimpleLogger<Int>()

        class Weather {
            @Published var temperature: Int
            @Published var receiver: Int

            init(temperature: Int) {
                self.temperature = temperature
                self.receiver = 0
            }
        }

        let weather = Weather(temperature: 10)
        var cancellables = Set<AnyCancellable>()

        // $receiver 에 sink 연결하자 마자 초기값 0 이 logger 에 들어간다.
        weather.$receiver
            .sink {
                logger.log($0)
            }
            .store(in: &cancellables)

        // $temperature 에 assign 연결하자 마자 초기값 10이 receiver 로 넘어간다.
        weather.$temperature
            .assign(to: &weather.$receiver)

        weather.receiver = 20
        weather.receiver = 30
        weather.temperature = 40
        weather.temperature = 50

        #expect(logger.result() == [0, 10, 20, 30, 40, 50])
    }

}
