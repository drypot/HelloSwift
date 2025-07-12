//
//  ObservableArrayTests.swift
//  HelloSwiftTests
//
//  Created by Kyuhyun Park on 11/19/24.
//

import Foundation
import HelloSwift
import Testing

struct ObservableArrayTests {

    struct Product {
        var name: String
    }

    class RefProduct {
        var name: String = ""

        init(name: String) {
            self.name = name
        }
    }

    @Observable class ObservableProduct {
        var name: String

        init(name: String) {
            self.name = name
        }
    }

    @Observable class Products {
        var valueProducts: [Product] = []
        var refProducts: [RefProduct] = []
        var observableProducts: [ObservableProduct] = []
    }

    @Test func testValueElement() async throws {
        let logger = SimpleLogger<Int>()

        let products = Products()
        products.valueProducts.append(Product(name: "Item1"))

        withObservationTracking {
            _ = products.valueProducts
        } onChange: {
            logger.log(1)
        }

        // 어레이 자체의 변화에 onChange 가 호출된다.
        products.valueProducts.append(Product(name: "Item2"))

        #expect(logger.result() == [1])
    }

    @Test func testValueElement2() async throws {
        let logger = SimpleLogger<Int>()

        let products = Products()
        products.valueProducts.append(Product(name: "Item1"))

        withObservationTracking {
            _ = products.valueProducts
        } onChange: {
            logger.log(1)
        }

        // 밸류 엘리먼트 변화에 onChange 가 호출된다.
        products.valueProducts[0].name = "Item1Ver2"

        #expect(logger.result() == [1])
    }

    @Test func testValueElement3() async throws {
        let logger = SimpleLogger<Int>()

        let products = Products()
        products.valueProducts.append(Product(name: "Item1"))

        withObservationTracking {
            _ = products.valueProducts
        } onChange: {
            logger.log(1)
        }

        // 업데이트가 여러번 발생해도 onChange 는 한번만 호출된다.
        products.valueProducts.append(Product(name: "Item2"))
        products.valueProducts.append(Product(name: "Item3"))
        products.valueProducts.append(Product(name: "Item4"))

        #expect(logger.result() == [1])
    }

    @Test func testReferenceElement1() async throws {
        let logger = SimpleLogger<Int>()

        let products = Products()
        products.refProducts.append(RefProduct(name: "Item1"))

        withObservationTracking {
            _ = products.refProducts
        } onChange: {
            logger.log(1)
        }

        // 어레이 자체의 변화에 onChange 가 호출된다.
        products.refProducts.append(RefProduct(name: "Item2"))

        #expect(logger.result() == [1])
    }

    @Test func testReferenceElement2() async throws {
        let logger = SimpleLogger<Int>()

        let products = Products()
        products.refProducts.append(RefProduct(name: "Item1"))

        withObservationTracking {
            _ = products.refProducts
        } onChange: {
            logger.log(1)
        }

        // 오브젝트 엘리먼트에 대한 업데이트엔 onChange 가 발생하지 않는다.
        products.refProducts[0].name = "Item1Ver2"

        #expect(logger.result() == [])
    }

    @Test func testReferenceElement3() async throws {
        let logger = SimpleLogger<Int>()

        let products = Products()
        products.refProducts.append(RefProduct(name: "Item1"))

        withObservationTracking {
            _ = products.refProducts[0].name
        } onChange: {
            logger.log(1)
        }

        products.refProducts[0].name = "Item1Ver2"

        #expect(logger.result() == [])
    }

    @Test func testObservableElement1() async throws {
        let logger = SimpleLogger<Int>()

        let products = Products()
        products.observableProducts.append(ObservableProduct(name: "Item1"))

        withObservationTracking {
            _ = products.observableProducts
        } onChange: {
            logger.log(1)
        }

        // 어레이 자체의 변화에 onChange 가 호출된다.
        products.observableProducts.append(ObservableProduct(name: "Item2"))

        #expect(logger.result() == [1])
    }

    @Test func testObservableElement2() async throws {
        let logger = SimpleLogger<Int>()

        let products = Products()
        products.observableProducts.append(ObservableProduct(name: "Item1"))

        withObservationTracking {
            _ = products.observableProducts
        } onChange: {
            logger.log(1)
        }

        // 오브젝트 엘리먼트에 대한 업데이트엔 onChange 가 발생하지 않는다.
        products.observableProducts[0].name = "Item1Ver2"

        #expect(logger.result() == [])
    }

    @Test func testObservableElement3() async throws {
        let logger = SimpleLogger<Int>()

        let products = Products()
        products.observableProducts.append(ObservableProduct(name: "Item1"))

        withObservationTracking {
            _ = products.observableProducts[0].name
        } onChange: {
            logger.log(1)
        }

        // 오브젝트 엘리먼트를 구체적으로 노출시켜주면 onChange 가 발생한다.
        products.observableProducts[0].name = "Item1Ver2"

        #expect(logger.result() == [1])
    }

}
