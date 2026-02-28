//
//  TypeErasureTests.swift
//  HelloSwiftTests
//
//  Created by Kyuhyun Park on 11/7/24.
//

import Foundation
import Testing

struct TypeErasureTests {

    // Protocol

    protocol ContainerProtocol {
        associatedtype Content
        var content: Content? { get }
        func maxQuantity() -> Int
    }

    // Struct

    struct ContainerX<Content>: ContainerProtocol {
        var content: Content?

        init(_ content: Content) {
            self.content = content
        }

        func maxQuantity() -> Int {
            return 3
        }
    }

    struct ContainerY<Content>: ContainerProtocol {
        var content: Content?

        init(_ content: Content) {
            self.content = content
        }

        func maxQuantity() -> Int {
            return 5
        }
    }

    @Test func testAny() throws {
        let xa: any ContainerProtocol = ContainerX("abc")
        let ya: any ContainerProtocol = ContainerY("123")
        let seq: [any ContainerProtocol] = [xa, ya]
        var iterator = seq.makeIterator()

        #expect(iterator.next()?.content as! String == "abc")
        #expect(iterator.next()?.content as! String == "123")
    }

    @Test func testAnyContainerClass() throws {

        class AnyContainerBase<Content>: ContainerProtocol {
            var content: Content? {
                fatalError()
            }
            init() {
            }
            func maxQuantity() -> Int {
                fatalError()
            }
        }

        final class AnyContainerBox<Container: ContainerProtocol> : AnyContainerBase<Container.Content> {

            let container: Container

            init(_ container: Container) {
                self.container = container
            }

            override var content: Container.Content? {
                return container.content
            }

            override func maxQuantity() -> Int {
                return container.maxQuantity()
            }
        }

        class AnyContainer<Content>: ContainerProtocol {
            private let box: AnyContainerBase<Content>

            init<Container: ContainerProtocol>(_ container: Container) where Container.Content == Content {
                self.box = AnyContainerBox(container)
            }

            var content: Content? {
                return box.content
            }

            func maxQuantity() -> Int {
                return box.maxQuantity()
            }
        }

        let ca = AnyContainer(ContainerX("abc"))
        let cb = AnyContainer(ContainerY("123"))
        let seq = [ca, cb]
        var iterator = seq.makeIterator()

        #expect(iterator.next()?.content == "abc")
        #expect(iterator.next()?.content == "123")
    }

    @Test func testAnyContainerStructWithClosure() throws {

        struct AnyContainer<Content>: ContainerProtocol {
            var content: Content?
            private let _maxQuantity: () -> Int

            init<Container: ContainerProtocol>(_ container: Container)
            where Container.Content == Content {
                self.content = container.content
                _maxQuantity = container.maxQuantity
            }

            func maxQuantity() -> Int {
                return _maxQuantity()
            }
        }

        let ca = AnyContainer(ContainerX("abc"))
        let cb = AnyContainer(ContainerY("123"))
        let seq = [ca, cb]
        var iterator = seq.makeIterator()

        #expect(iterator.next()?.content == "abc")
        #expect(iterator.next()?.content == "123")
    }

}
