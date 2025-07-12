//
//  KeyPathTests.swift
//  HelloSwiftTests
//
//  Created by Kyuhyun Park on 11/10/24.
//

import Foundation
import Testing

// https://docs.swift.org/swift-book/documentation/the-swift-programming-language/expressions/#Key-Path-Expression

// Key-Path Expression 은 KeyPath 클래스의 오브젝트를 만든다.
// KeyPath 클래스의 init 를 사용해서 직접 오브젝트를 생성하는 건 불가능하다고 한다.
// 레퍼런스 소유 관련해서 런타임에서 임의로 판단할 수 없는 것들이 있다고.

struct KeyPathTests {

    @Test func testKeyPath() throws {

        struct Pet {
            var name: String
            var age: Int
        }

        let pet = Pet(name: "max", age: 12)
        let namePath = \Pet.name
        let agePath = \Pet.age

        #expect(pet[keyPath: namePath] == "max")
        #expect(pet[keyPath: agePath] == 12)
    }

    @Test func testDynamicMemberLookup() throws {

        @dynamicMemberLookup
        struct DynamicStruct {
            let dictionary = ["someDynamicMember": 1,
                              "someOtherMember": 2]
            subscript(dynamicMember member: String) -> Int {
                return dictionary[member] ?? 3
            }
        }

        let s = DynamicStruct()

        do {
            #expect(s.someDynamicMember == 1)
            #expect(s.someOtherMember == 2)
            #expect(s.xyz == 3)
        }

        do {
            #expect(s[dynamicMember: "someDynamicMember"] == 1)
            #expect(s[dynamicMember: "someOtherMember"] == 2)
            #expect(s[dynamicMember: "xyz"] == 3)
        }
    }

    @Test func testDynamicMemberLookupWithKeyPath() throws {

        struct Point { var x, y: Int }

        @dynamicMemberLookup
        struct PassthroughWrapper<Value> {
            var value: Value
            subscript<T>(dynamicMember member: KeyPath<Value, T>) -> T {
                get { return value[keyPath: member] }
            }
        }

        let point = Point(x: 10, y: 20)
        let wrapper = PassthroughWrapper(value: point)

        #expect(wrapper.x == 10)
        #expect(wrapper.y == 20)
    }

}
