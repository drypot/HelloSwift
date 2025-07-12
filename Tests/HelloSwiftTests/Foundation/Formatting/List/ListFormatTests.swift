//
//  ListFormatTests.swift
//  HelloSwiftTests
//
//  Created by Kyuhyun Park on 3/18/25.
//

import Foundation
import Testing

// Data Formatting
// https://developer.apple.com/documentation/foundation/data_formatting

// ListFormatStyle
// https://developer.apple.com/documentation/foundation/listformatstyle

// A list format style creates human readable text from a Sequence of values.

struct ListFormatTests {

    @Test func testFactory() throws {

        let seq = ["Kristin", "Paul", "Ana", "Bill"]

        let formatted =
            seq.formatted(
                .list(type: .and, width: .standard)
                .locale(Locale(identifier: "ko_KR"))
            )

        #expect(formatted == "Kristin, Paul, Ana 및 Bill")

        let formattedUS =
            seq.formatted(
                .list(type: .and, width: .standard)
                .locale(Locale(identifier: "en_US"))
            )

        #expect(formattedUS == "Kristin, Paul, Ana, and Bill")
    }

    @Test func testFactory2() throws {
        let seq = 0..<5

        // Element 가 String 이 아니면 먼저 String 을 만들어야 한다.
        #expect(
            seq.map(String.init).formatted(.list(type: .and, width: .short)) ==
            "0, 1, 2, 3 및 4"
        )

        // 아니면 memberStyle 을 지정해야 한다.
        #expect(
            seq.formatted(.list(memberStyle: .number, type: .or, width: .short)) ==
            "0, 1, 2, 3 또는 4"
        )
    }

    @Test func testListFormatStyle() throws {
        let seq = 0..<5

        var style = ListFormatStyle<IntegerFormatStyle<Int>, Range<Int>>(memberStyle: .number)
        style.listType = .and
        style.width = .standard
        style.locale = Locale(identifier: "en_US")

        #expect(seq.formatted(style) == "0, 1, 2, 3, and 4")

        style.width = .narrow

        #expect(seq.formatted(style) == "0, 1, 2, 3, 4")
    }
}
