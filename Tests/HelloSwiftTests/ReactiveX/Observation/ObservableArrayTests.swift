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

    struct StructProduct {
        var name: String
    }

    class ClassProduct {
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
        var structProducts: [StructProduct] = []
        var classProducts: [ClassProduct] = []
        var observableProducts: [ObservableProduct] = []
    }

    @Test func testValueElement() async throws {
        let logger = SimpleLogger<Int>()

        let products = Products()
        products.structProducts.append(StructProduct(name: "Item1"))

        withObservationTracking {
            _ = products.structProducts
        } onChange: {
            logger.log(1)
        }

        // 어레이 자체의 변화에 onChange 가 호출된다.
        products.structProducts.append(StructProduct(name: "Item2"))

        #expect(logger.result() == [1])
    }

    @Test func testValueElement2() async throws {
        let logger = SimpleLogger<Int>()

        let products = Products()
        products.structProducts.append(StructProduct(name: "Item1"))

        withObservationTracking {
            _ = products.structProducts
        } onChange: {
            logger.log(1)
        }

        // 밸류 엘리먼트 변화에 onChange 가 호출된다.
        products.structProducts[0].name = "Item1Ver2"

        #expect(logger.result() == [1])
    }

    @Test func testValueElement3() async throws {
        let logger = SimpleLogger<Int>()

        let products = Products()
        products.structProducts.append(StructProduct(name: "Item1"))

        withObservationTracking {
            _ = products.structProducts
        } onChange: {
            logger.log(1)
        }

        // 업데이트가 여러번 발생해도 onChange 는 한번만 호출된다.
        products.structProducts.append(StructProduct(name: "Item2"))
        products.structProducts.append(StructProduct(name: "Item3"))
        products.structProducts.append(StructProduct(name: "Item4"))

        #expect(logger.result() == [1])
    }

    @Test func testReferenceElement1() async throws {
        let logger = SimpleLogger<Int>()

        let products = Products()
        products.classProducts.append(ClassProduct(name: "Item1"))

        withObservationTracking {
            _ = products.classProducts
        } onChange: {
            logger.log(1)
        }

        // 어레이 자체의 변화에 onChange 가 호출된다.
        products.classProducts.append(ClassProduct(name: "Item2"))

        #expect(logger.result() == [1])
    }

    @Test func testReferenceElement2() async throws {
        let logger = SimpleLogger<Int>()

        let products = Products()
        products.classProducts.append(ClassProduct(name: "Item1"))

        withObservationTracking {
            _ = products.classProducts
        } onChange: {
            logger.log(1)
        }

        // 오브젝트 엘리먼트에 대한 업데이트엔 onChange 가 발생하지 않는다.
        products.classProducts[0].name = "Item1Ver2"

        #expect(logger.result() == [])
    }

    @Test func testReferenceElement3() async throws {
        let logger = SimpleLogger<Int>()

        let products = Products()
        products.classProducts.append(ClassProduct(name: "Item1"))

        withObservationTracking {
            _ = products.classProducts[0].name
        } onChange: {
            logger.log(1)
        }

        products.classProducts[0].name = "Item1Ver2"

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
