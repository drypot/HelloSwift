//
//  ObservableTests.swift
//  HelloSwiftTests
//
//  Created by Kyuhyun Park on 11/19/24.
//

import Foundation
import MyLibrary
import Testing

// https://developer.apple.com/documentation/observation

struct ObservableTests {

    @Observable   // @Observable 은 class에만 쓸 수 있다. 
    class Pet {
        var name: String
        var age: Int

        init(name: String, age: Int) {
            self.name = name
            self.age = age
        }
    }

    @Test func testWhenExposedPropertyChanged() async throws {
        let logger = SimpleLogger<Int>()

        let pet = Pet(name: "max", age: 7)

        withObservationTracking {
            logger.log(1)
            _ = pet.name
            _ = pet.age
        } onChange: {
            logger.log(2)
        }

        logger.log(3)
        pet.name = "max juior"

        logger.log(4)
        pet.age = 2

        // 노출된 프로퍼티가 업데이트되어 onChange 가 호출되었다.
        // 아무 프로퍼티나 업데이트 될 때 한번만 호출된다.

        #expect(logger.result() == [1, 3, 2, 4])
    }

    @Test func testWhenExposedPropertyChanged2() async throws {
        let logger = SimpleLogger<Int>()

        let pet = Pet(name: "max", age: 7)

        withObservationTracking {
            logger.log(1)
            _ = pet.name
            _ = pet.age
        } onChange: {
            logger.log(2)
        }

        withObservationTracking {
            logger.log(3)
            _ = pet.name
            _ = pet.age
        } onChange: {
            logger.log(2) // 위아래 onChange 가 무작위로 호출되서 log(2) 로 통일했다.
        }

        logger.log(5)
        pet.name = "max juior"

        logger.log(6)
        pet.age = 2

        // 노출된 프로퍼티가 업데이트되어 onChange 가 호출되었다.
        // 아무 프로퍼티나 업데이트 될 때 한번만 호출된다.

        #expect(logger.result() == [1, 3, 5, 2, 2, 6])
    }

    @Test func testWhenNotExposedPropertyChanged() async throws {
        let logger = SimpleLogger<Int>()

        let pet = Pet(name: "max", age: 7)

        withObservationTracking {
            logger.log(1)
            _ = pet.name
        } onChange: {
            logger.log(2)
        }

        logger.log(3)
        pet.age = 2

        // name 프로퍼티가 노출되었는데 age 프로퍼티를 변경하니 onChange 가 호출되지 않았다.

        #expect(logger.result() == [1, 3])
    }

}
