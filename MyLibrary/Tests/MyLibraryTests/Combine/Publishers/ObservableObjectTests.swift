//
//  ObservableObjectTests.swift
//  HelloSwiftTests
//
//  Created by Kyuhyun Park on 12/9/24.
//

import Foundation
import Combine
import MyLibrary
import Testing

// https://developer.apple.com/documentation/combine/observableobject

struct ObservableObjectTests {

    @Test func testObjectWillChange() throws {
        let logger = SimpleLogger<Int>()
        var cancellables = Set<AnyCancellable>()

        // An ObservableObject synthesizes an objectWillChange publisher
        // that emits the changed value before any of its @Published properties changes.

        class Contact: ObservableObject {
            @Published var name: String
            @Published var age: Int

            init(name: String, age: Int) {
                self.name = name
                self.age = age
            }
        }

        let john = Contact(name: "John Appleseed", age: 24)

        john.objectWillChange
            .sink { _ in
                logger.log(99)
            }
            .store(in: &cancellables)

        john.$age
            .sink {
                logger.log($0)
            }
            .store(in: &cancellables)

        #expect(logger.result() == [24])

        john.age += 1

        #expect(logger.result() == [24, 99, 25])

        john.age += 1

        #expect(logger.result() == [24, 99, 25, 99, 26])
    }


}
