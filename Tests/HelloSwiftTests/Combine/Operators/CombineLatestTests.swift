//
//  CombineLatestTests.swift
//  HelloSwiftTests
//
//  Created by Kyuhyun Park on 12/8/24.
//

import Foundation
import Combine
import HelloSwift
import Testing

struct CombineLatestTests {

    @Test func test() throws {
        let logger = SimpleLogger<Int>()
        var cancellables = Set<AnyCancellable>()

        let p1 = PassthroughSubject<Int, Never>()
        let p2 = PassthroughSubject<Int, Never>()

        Publishers.CombineLatest(p1, p2)
            .map { $0 + $1 }
            .sink { logger.log($0) }
            .store(in: &cancellables)

        p1.send(10)

        p1.send(20)
        p2.send(1)
        p2.send(2)

        p1.send(30)
        p2.send(3)
        p2.send(4)

        #expect(logger.result() == [21, 22, 32, 33, 34])
    }

    @Test func test2() throws {
        let logger = SimpleLogger<Int>()

        let p1 = PassthroughSubject<Int, Never>()
        let p2 = PassthroughSubject<Int, Never>()
        var cancellables = Set<AnyCancellable>()

        p1
            .combineLatest(p2) { $0 + $1 }
            .sink { logger.log($0) }
            .store(in: &cancellables)

        p1.send(10)

        p1.send(20)
        p2.send(1)
        p2.send(2)

        p1.send(30)
        p2.send(3)
        p2.send(4)

        #expect(logger.result() == [21, 22, 32, 33, 34])
    }

}
