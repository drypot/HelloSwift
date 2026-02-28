//
//  StringCreatingTests.swift
//  HelloSwiftTests
//
//  Created by Kyuhyun Park on 10/28/24.
//

import Foundation
import Testing

// String.Element == Character

struct StringCreatingTests {

    @Test func testEmtpyString() throws {
        #expect(String() == "")
    }

    @Test func testStringFromCharacter() throws {
        let ch: Character = "a"
        #expect(String(ch) == "a")
    }

    @Test func testStringFromCharacterSequence() throws {
        let vowels: [Character] = ["a", "e", "i", "o", "u"]
        #expect(String(vowels) == "aeiou")
    }

    @Test func testStringFromCharacterSequence2() throws {
        let str = "The rain in Spain stays mainly in the plain."
        let aaa = String(str.lazy.filter { $0 == "a" })
        #expect(aaa == "aaaaa")
    }

    @Test func testStringFromSubstring() throws {
        let greeting = "Hi there! It's nice to meet you!"
        let endOfSentence = greeting.firstIndex(of: "!")!
        let firstSentence = greeting[...endOfSentence]
        #expect(firstSentence == "Hi there!")
        #expect(String(firstSentence) == "Hi there!")
    }

    @Test func testStringFromRepeating() throws {
        #expect(String(repeating: "abc", count: 3) == "abcabcabc")
    }

    @Test func testStringFromUnicodeScalar() throws {
        #expect(String(Unicode.Scalar(0x00E9)) == "é")
    }

    @Test func testStringFromData() throws {
        let data = "abc".data(using: .utf8)!
        #expect(String(data: data, encoding: .utf8) == "abc")
    }

    // UTF8 포인터에서 데이터 가져오는 생성자는 패스;

    @Test func testStringFormat() throws {
        #expect(String(format: "abc %@ %@", "def", "123") == "abc def 123") // %@: Object, including String

        #expect(String(format: "number: %04d", 77) == "number: 0077") // %d: Integer
        #expect(String(format: "pi: %.5f", Double.pi) == "pi: 3.14159") // %f: Floating-point number
        #expect(String(format: "hex: %02X", 255) == "hex: FF") // %x or %X: Lowercase or uppercase hexadecimal

        #expect(String.localizedStringWithFormat("abc %@ %@", "def", "123") == "abc def 123")
    }

    // Localized String 은 다음에

//    init(
//        localized keyAndValue: String.LocalizationValue,
//        table: String? = nil,
//        bundle: Bundle? = nil,
//        locale: Locale = .current,
//        comment: StaticString? = nil
//    )

    @Test func testStringFromBaseN() throws {
        #expect(String(44) == "44")
        #expect(String(44, radix: 10) == "44")
        #expect(String(44, radix: 6) == "112") // 6*7 + 2 -> 6*6*1 + 6*1 + 2 -> 112

        #expect(String(255, radix: 16) == "ff")
        #expect(String(255, radix: 16, uppercase: true) == "FF")
    }

    // C String 에서 데이터 가져오는 생성자는 패스;

    @Test func testStringFromLosslessStringConvertible() throws {

        struct Point: LosslessStringConvertible {
            let x: Int, y: Int

            init(x: Int, y: Int) {
                self.x = x
                self.y = y
            }

            init?(_ description: String) {
                x = 99
                y = 99
            }

            var description: String {
                return "(\(x), \(y))"
            }
        }

        let point = Point(x: 10, y: 20)

        #expect(String(point) == "(10, 20)")
        #expect(String(describing: point) == "(10, 20)")
    }

    @Test func testStringFromDescription() throws {

        struct Point {
            let x: Int, y: Int
        }

        let point = Point(x: 10, y: 20)

        #expect(String(describing: point) == "Point(x: 10, y: 20)")
    }

//    @Test func testStringFromURL() throws {
//        init(
//            contentsOf url: URL,
//            encoding enc: String.Encoding
//        ) throws
//    }

//    @Test func testStringFromFile() throws {
//        init(
//            contentsOfFile path: String,
//            encoding enc: String.Encoding
//        ) throws
//    }

}
