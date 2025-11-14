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

        // 노출된 프로퍼티가 업데이트되면 onChange 가 호출된다.
        pet.name = "max juior"

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

        // 노출되지 않은 프로퍼티가 업데이트되면 호출되지 않는다.
        pet.age = 2

        #expect(logger.result() == [1])
    }

}
