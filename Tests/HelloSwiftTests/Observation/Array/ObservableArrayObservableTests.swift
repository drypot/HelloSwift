//
//  ObservableArrayObservableTests.swift
//  HelloSwift
//
//  Created by Kyuhyun Park on 11/19/24.
//


import Foundation
import HelloSwift
import Testing

struct ObservableArrayObservableTests {

    @Observable class Product {
        var name: String = ""

        init(name: String) {
            self.name = name
        }
    }

    @Observable class Model {
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

        model.products.append(Product(name: "Product2"))

        // 새 Element 가 추가되면 onChange 가 호출된다.

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

        model.products[0].name = "Product1b"

        // arry 만 노출된 상태에서는 Element 가 수정되도 onChange 가 호출되지 않는다.

        #expect(logger.result() == [])
    }

    @Test func testWhenElementUpdated2() async throws {
        let logger = SimpleLogger<Int>()

        let model = Model()
        model.products.append(Product(name: "Product1"))

        withObservationTracking {
            _ = model.products[0].name
        } onChange: {
            logger.log(1)
        }

        model.products[0].name = "Product1b"

        // Element property가 노출되면 property가 수정될 때 onChange 가 호출된다.

        #expect(logger.result() == [1])
    }

}
