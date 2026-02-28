//
//  FutureTests.swift
//  HelloSwiftTests
//
//  Created by Kyuhyun Park on 12/2/24.
//

import Foundation
@preconcurrency import Combine
import MyLibrary
import Testing

struct FutureTests {

    @Test func testFuture() throws {
        let logger = SimpleLogger<Int>()
        var cancellables = Set<AnyCancellable>()

        // Future 는 클로져를 인자로 받는데 이 클로져는 promise 펑션을 인자로 받는다.
        // promise 펑션은 Result 타입을 인자로 받는다.
        // Future 클로져에서 작업이 끝나면 promise 를 콜해서 결과를 넘긴다.
        // Future 는 single value 만 생성하고 종료된다.

        // Futures will run their closure immediately
        // without waiting for a subscriber to be attached

        let future = Future<_, Never> { promise in
            logger.log(10)
            promise(.success(99))
        }

        logger.log(20)

        future
            .sink { value in
                logger.log(value)
            }
            .store(in: &cancellables)

        #expect(logger.result() == [10, 20, 99])
    }

    @Test func testDeferredFuture() throws {
        let logger = SimpleLogger<Int>()
        var cancellables = Set<AnyCancellable>()

        // Future 는 인자로 받은 closure 를 subscriber 를 기다리지 않고 바로 실행해 버린다.
        // 해서 subscriber 를 기다리려면 Deferred 로 감싸야 한다.

        let future = Deferred {
            Future<_, Never> { promise in
                logger.log(10)
                promise(.success(99))
            }
        }

        logger.log(20)

        future
            .sink { value in
                logger.log(value)
            }
            .store(in: &cancellables)

        #expect(logger.result() == [20, 10, 99])
    }

    @Test func testFutureAwait() async throws {

        // 동기 코드를 비동기 환경에 연결하는데 사용할 수도 있다.
        // value 를 await 한다.

        let value1 = await Future { promise in
            promise(.success(10))
        }.value

        #expect(value1 == 10)

        // 하지만 withCheckedContinuation 이 기능상 더 무난해 보인다.

        let value2 = await withCheckedContinuation { continuation in
            continuation.resume(returning: 20)
        }

        #expect(value2 == 20)
    }

}
