//
//  StringTests.swift
//  HelloSwiftTests
//
//  Created by Kyuhyun Park on 10/28/24.
//

import Testing

struct StringTests {

    @Test func testString() throws {
        let name = "Rosa"

        #expect("Welcome, \(name)!" == "Welcome, Rosa!")
        #expect("A" + "B" == "AB")
    }

    @Test func testMultilineString() throws {
        let m1 = """
            abc
            """

        #expect(m1 == "abc")

        let m2 = """
            abc
            
            """

        #expect(m2 == "abc\n")
    }

    @Test func testStringHaveValueSemantics() throws {
        let hello = "hello"
        var hello2 = hello
        hello2 += ", world"

        #expect(hello == "hello")
        #expect(hello2 == "hello, world")
    }

    @Test func testStringComparison() throws {
        #expect("Cafe\u{301}" == "Café")
    }

    @Test func testCount() throws {

        // 🇰🇷
        // Regional Indicator Symbol Letter K + Regional Indicator Symbol Letter R
        //
        // https://unicodeplus.com/U+1F1F0
        // https://unicodeplus.com/U+1F1F7

        let flag = "🇰🇷"
        #expect(flag.count == 1)
        #expect(flag.unicodeScalars.count == 2)
        #expect(flag.utf8.count == 8)
        #expect(flag.utf16.count == 4)
    }

    @Test func testIsEmpty() throws {
        #expect("".isEmpty == true)
        #expect("abc".isEmpty == false)
    }
}
