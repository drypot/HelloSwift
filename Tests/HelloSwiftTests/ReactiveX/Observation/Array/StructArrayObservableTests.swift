//
//  StructArrayObservableTests.swift
//  HelloSwift
//
//  Created by Kyuhyun Park on 11/19/24.
//


import Foundation
import HelloSwift
import Testing

struct StructArrayObservableTests {

    struct Product {
        var name: String
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

        // Element 가 수정되면 onChange 가 호출된다.

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

        model.products[0].name = "Product1b"

        // array 가 관찰대상이기 때문에 어떤 엘리먼트가 노출되는지는 상관이 없다.

        #expect(logger.result() == [1])
    }

    @Test func testJustOnce() async throws {
        let logger = SimpleLogger<Int>()

        let products = Model()
        products.products.append(Product(name: "Product1"))

        withObservationTracking {
            _ = products.products
        } onChange: {
            logger.log(1)
        }

        logger.log(2)
        products.products.append(Product(name: "Product2"))
        logger.log(3)
        products.products.append(Product(name: "Product3"))
        logger.log(4)
        products.products.append(Product(name: "Product4"))
        logger.log(5)

        // onChange 는 한번만 호출된다.

        #expect(logger.result() == [2, 1, 3, 4, 5])
    }

}
