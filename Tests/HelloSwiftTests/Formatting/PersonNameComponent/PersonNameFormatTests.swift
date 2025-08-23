//
//  PersonNameFormatTests.swift
//  HelloSwiftTests
//
//  Created by Kyuhyun Park on 3/19/25.
//

import Foundation
import Testing

// Data Formatting
// https://developer.apple.com/documentation/foundation/data_formatting

// PersonNameComponents
// https://developer.apple.com/documentation/foundation/personnamecomponents

// PersonNameComponents.FormatStyle
// https://developer.apple.com/documentation/foundation/personnamecomponents/formatstyle

struct PersonNameFormatTests {

    @Test func testFactory() throws {

        // https://developer.apple.com/documentation/foundation/personnamecomponents/formatstyle/3798926-name
        // name(style:): Creates a person name components format style using the provided format style.

        do {
            var name = PersonNameComponents()
            name.familyName = "Clark"
            name.givenName = "Thomas"
            name.middleName = "Louis"
            name.nickname = "Tom"
            name.namePrefix = "Dr."
            name.nameSuffix = "Esq."

            let lc = Locale(identifier: "en_US")

            #expect(name.formatted(.name(style: .long).locale(lc)) == "Dr. Thomas Louis Clark Esq.")
            #expect(name.formatted(.name(style: .medium).locale(lc)) == "Thomas Clark")
            #expect(name.formatted(.name(style: .short).locale(lc)) == "Tom")
            #expect(name.formatted(.name(style: .abbreviated).locale(lc)) == "TC")
        }
        do {
            var name = PersonNameComponents()
            name.familyName = "홍"
            name.givenName = "길동"
            name.middleName = "중간"
            name.namePrefix = "머리"
            name.nickname = "별명"
            name.nameSuffix = "꼬리"

            let lc = Locale(identifier: "ko_KR")

            #expect(name.formatted(.name(style: .long).locale(lc)) == "머리홍길동중간꼬리")
            #expect(name.formatted(.name(style: .medium).locale(lc)) == "홍길동")
            #expect(name.formatted(.name(style: .short).locale(lc)) == "별명")
            #expect(name.formatted(.name(style: .abbreviated).locale(lc)) == "길동")
        }
    }

    @Test func testStyle() throws {
        var style = PersonNameComponents.FormatStyle(
            style: .long,
            locale: Locale(identifier: "en_US")
        )

        var name = PersonNameComponents()
        name.familyName = "Clark"
        name.givenName = "Thomas"
        name.middleName = "Louis"
        name.nickname = "Tom"
        name.namePrefix = "Dr."
        name.nameSuffix = "Esq."

        #expect(name.formatted(style) == "Dr. Thomas Louis Clark Esq.")

        style.style = .medium
        #expect(name.formatted(style) == "Thomas Clark")

        style.style = .short
        #expect(name.formatted(style) == "Tom")

        style.style = .abbreviated
        #expect(name.formatted(style) == "TC")
    }
}
