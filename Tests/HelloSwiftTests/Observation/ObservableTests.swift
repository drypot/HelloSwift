//
//  ObservableTests.swift
//  HelloSwiftTests
//
//  Created by Kyuhyun Park on 11/19/24.
//

import Foundation
import HelloSwift
import Testing

// https://developer.apple.com/documentation/observation

struct ObservableTests {

    @Observable class Pet {
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
            _ = pet.name
            logger.log(1)
        } onChange: {
            logger.log(2)
        }

        pet.name = "max juior"

        // 노출된 name 프로퍼티가 업데이트되어 onChange 가 호출되었다.

        #expect(logger.result() == [1, 2])
    }

    @Test func testWhenExposedPropertyChangedMultipleTimes() async throws {
        let logger = SimpleLogger<Int>()

        let pet = Pet(name: "max", age: 7)

        withObservationTracking {
            _ = pet.name
            logger.log(1)
        } onChange: {
            logger.log(2)
        }

        pet.name = "max juior"
        pet.name = "max juior again"

        // 노출된 name 프로퍼티가 업데이트되어 onChange 가 호출되었다.
        // 한번만 호출되었다.

        #expect(logger.result() == [1, 2])
    }

    @Test func testWhenNotExposedPropertyChanged() async throws {
        let logger = SimpleLogger<Int>()

        let pet = Pet(name: "max", age: 7)

        withObservationTracking {
            _ = pet.name
            logger.log(1)
        } onChange: {
            logger.log(2)
        }

        pet.age = 2

        // name 프로퍼티가 노출되었는데 age 프로퍼티를 변경하니 onChange 가 호출되지 않았다.

        #expect(logger.result() == [1])
    }

}
