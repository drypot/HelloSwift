//
//  ObservableStructArrayTests.swift
//  HelloSwift
//
//  Created by Kyuhyun Park on 11/19/24.
//


import Foundation
import HelloSwift
import Testing

struct ObservableStructArrayTests {

    struct Product {
        var name: String
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

        // Element 가 수정되면 onChange 가 호출된다.
        model.products[0].name = "Product1b"
        #expect(logger.result() == [1])
    }

    @Test func testWhenElementUpdated2() async throws {
        let logger = SimpleLogger<Int>()

        let model = Model()
        model.products.append(Product(name: "Product1"))
        model.products.append(Product(name: "Product2"))

        withObservationTracking {
            _ = model.products[1]
        } onChange: {
            logger.log(1)
        }

        // array 가 관찰대상이기 때문에 어떤 엘리먼트가 노출되는지는 상관이 없다.
        model.products[0].name = "Product1b"
        #expect(logger.result() == [1])
    }

}
