//
//  TypeTests.swift
//  HelloSwiftTests
//
//  Created by Kyuhyun Park on 10/21/24.
//

import Testing

struct TypeTests {

    struct MyStruct {
        var value: Int
    }

    @Test func testTypeSelf() throws {

        let instance: MyStruct = MyStruct(value: 10)
        let typeOfInstance: MyStruct.Type = type(of: instance)
        let typeSelf: MyStruct.Type = MyStruct.self

        #expect(typeOfInstance == typeSelf)
    }

    @Test func testInsanceFromType() throws {
        let type: MyStruct.Type = MyStruct.self
        let instance: MyStruct = type.init(value: 20)

        #expect(instance.value == 20)
    }

}
