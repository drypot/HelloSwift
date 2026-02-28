//
//  ClassInitTests.swift
//  HelloSwift
//
//  Created by Kyuhyun Park on 10/14/24.
//

import Foundation
import Testing

struct ClassInitTest {

    @Test func testDefaultInitializer() {

        class Vehicle {
            var speed: Int = 0
        }

        let car = Vehicle()

        #expect(car.speed == 0)
    }

    @Test func testDesignatedInitializer() {

        class Car {
            var speed: Int
            var brand: String

            // Designated Initializer (지정 생성자)
            // 클래스의 모든 속성을 초기화해야 한다.
            // 필요하면 부모 클래스의 initializer를 호출해야 한다.

            init(speed: Int, brand: String) {
                self.speed = speed
                self.brand = brand
            }

            // 구조체에서는 자동 생성된 기본 initializer가 제공되지만,
            // 클래스는 자동 생성되지 않으므로 필요에 따라 직접 정의해야 한다.
        }

        let car = Car(speed: 100, brand: "Tesla")

        #expect(car.speed == 100)
    }

    @Test func testTwoDesignatedInitializers() {

        class Car {
            var speed: Int
            var brand: String

            init(speed: Int, brand: String) {
                self.speed = speed
                self.brand = brand
            }

            // Designated Initializer (지정 생성자)
            // 클래스는 적어도 하나의 designated initializer를 가져야 한다.
            // 다르게 말하면 두 개 이상의 designated initializer가 있을 수 있다. 억지로 만든다면;

            init(speed: Int) {
                self.speed = speed
                self.brand = "nobrand"
            }
        }

        let car = Car(speed: 100, brand: "Tesla")

        #expect(car.speed == 100)
    }

    @Test func testConvenienceInitializer() {

        class Car {
            var speed: Int
            var brand: String

            // Designated initializer (지정 생성자)

            init(speed: Int, brand: String) {
                self.speed = speed
                self.brand = brand
            }

            // Convenience initializer (편의 생성자)
            // 반드시 같은 클래스의 다른 initializer를 호출해야 한다.
            // 일반적으로 지정 생성자를 호출한다.
            // Convenience initializer가 아니면 다른 initializer를 호출할 수 없다.

            convenience init() {
                self.init(speed: 100, brand: "Unknown")
            }

            // 생성자 초기화 순서
            // Convenience Initializer →
            // Designated Initializer →
            // 부모 클래스의 Designated Initializer

        }

        let car = Car()

        #expect(car.speed == 100)
        #expect(car.brand == "Unknown")
    }

    @Test func testInitializerInInheritance() {

        class Vehicle {
            var speed: Int

            init(speed: Int) {
                self.speed = speed
            }
        }

        class Car: Vehicle {
            var brand: String

            // Designated initializer
            init(speed: Int, brand: String) {
                self.brand = brand
                super.init(speed: speed) // call super init
            }
        }

        let car = Car(speed: 120, brand: "Toyota")

        #expect(car.speed == 120)
        #expect(car.brand == "Toyota")
    }

    @Test func testRequiredInitializer() {

        // Swift 에는 다음과 같은 규칙이 있다.
        // 서브클래스에 Designated initializer가 있다면 부모의 initializer는 계승되지 않는다.
        // 다르게 말하면 부모 클래스에 있는 initializer가 서브 클래스에는 없을 수 있다.

        // 서브 클래스가 반드시 가지고 있어야 하는 initializer에는 required 표시를 한다.

        protocol Flier {
            init()
        }

        class Bird: Flier {

            // 프로토콜을 보장하려면 서브 클래스들도 init()를 가지고 있음이 보장되어야 한다.
            // 이건 경우 required 를 적어준다.
            // required 를 넣지 않으면 컴파일 에러가 난다.

            required init() {}
        }

        class ColoredBird: Bird {
            init(color: String) {
            }

            required convenience init() {
                self.init(color: "red")
            }
        }

    }

    @Test func testFailableInitializer() {

        class Car {
            var speed: Int
            var brand: String

            init?(speed: Int, brand: String) {
                guard speed > 0 else { return nil }
                self.speed = speed
                self.brand = brand
            }
        }

        let car = Car(speed: 100, brand: "Tesla")

        #expect(car?.speed == 100)

        let invalidCar = Car(speed: -10, brand: "Tesla")

        #expect(invalidCar == nil)
    }

    @Test func testDeinitializer() {

        class Handler {

            nonisolated(unsafe) static var checker = "uninited"

            init() {
                Self.checker = "inited"
            }

            deinit {
                Self.checker = "deinited"
            }
        }

        #expect(Handler.checker == "uninited")

        var handler: Handler? = Handler()
        _ = handler // remove unused variable warning

        #expect(Handler.checker == "inited")

        handler = nil

        #expect(Handler.checker == "deinited")
    }
}
