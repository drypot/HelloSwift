//
//  ObservableClassArrayTests.swift
//  HelloSwift
//
//  Created by Kyuhyun Park on 11/19/24.
//


import Foundation
import HelloSwift
import Testing

struct ObservableClassArrayTests {

    class Product {
        var name: String

        init(name: String = "") {
            self.name = name
        }
    }

    @Observable
    class Model {
        var products: [Product] = []
    }

    @Test func testWhenElementAppended() async throws {
        let logger = SimpleLogger<Int>()

        let model = Model()
        model.products.append(Product(name: "Product1"))

        withObservationTracking {
            _ = model.products
        } onChange: {
            logger.log(1)
        }

        // 새 Element 가 추가되면 onChange 가 호출된다.

        model.products.append(Product(name: "Product2"))
        #expect(logger.result() == [1])
    }

    @Test func testWhenElementUpdated() async throws {
        let logger = SimpleLogger<Int>()

        let model = Model()
        model.products.append(Product(name: "Product1"))

        withObservationTracking {
            _ = model.products
        } onChange: {
            logger.log(1)
        }

        // Element 가 수정되도 onChange 가 호출되지 않는다.

        model.products[0].name = "Product1b"
        #expect(logger.result() == [])
    }

}
