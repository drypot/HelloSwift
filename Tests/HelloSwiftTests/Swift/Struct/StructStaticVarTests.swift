//
//  StructStaticVarTests.swift
//  HelloSwiftTests
//
//  Created by Kyuhyun Park on 10/16/24.
//

import Foundation
import Testing

struct StructStaticVarTests {

    nonisolated(unsafe) static var log = [String]()

    nonisolated(unsafe) static var var1 = {
        log.append("var1")
        return "*"
    }()

    static var var2: String {
        log.append("var2")
        return "*"
    }

    @Test func testInitOrder() {
        Self.log.append("start")

        // static var1 이 lazy 하게 초기화 된다.
        let _ = Self.var1

        // var2 가 처음으로 computed 된다.
        let _ = Self.var2

        // var1 은 다시 초기화되지 않는다.
        let _ = Self.var1

        // var2 는 다시 computed 된다.
        let _ = Self.var2

        Self.log.append("end")

        #expect(Self.log == ["start", "var1", "var2", "var2", "end"])
    }
}
