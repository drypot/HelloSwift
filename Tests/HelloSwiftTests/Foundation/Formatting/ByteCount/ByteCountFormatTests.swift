//
//  ByteCountFormatTests.swift
//  HelloSwiftTests
//
//  Created by Kyuhyun Park on 10/29/24.
//

import Foundation
import Testing

// Data Formatting
// https://developer.apple.com/documentation/foundation/data_formatting

// ByteCountFormatStyle
// https://developer.apple.com/documentation/foundation/bytecountformatstyle

// Measurement.FormatStyle.ByteCount
// https://developer.apple.com/documentation/foundation/measurement/formatstyle/bytecount

struct ByteCountFormatTests {

    @Test func testFactory() throws {

        // https://developer.apple.com/documentation/foundation/formatstyle/3867781-bytecount
        // byteCount(style:allowedUnits:spellsOutZero:includesActualByteCount:) : Returns a format style to format a data storage value.

        let count: Int64 = 1024
        #expect(count.formatted(.byteCount(style: .memory)) == "1kB")
    }

    @Test func testFile() throws {
        var style = ByteCountFormatStyle(
            style: .file,
            allowedUnits: [.all],
            spellsOutZero: true,
            includesActualByteCount: false,
            locale: Locale(identifier: "en_US")
        )

        #expect(0.formatted(style) == "Zero kB")
        #expect(512.formatted(style) == "512 bytes")
        #expect(3071.formatted(style) == "3 kB")
        #expect(4096.formatted(style) == "4 kB")
        #expect(60000.formatted(style) == "60 kB")
        #expect(65536.formatted(style) == "66 kB")
        #expect(983748334.formatted(style) == "983.7 MB")
        #expect(304828748323.formatted(style) == "304.83 GB")

        style.includesActualByteCount = true

        #expect(0.formatted(style) == "Zero kB")
        #expect(512.formatted(style) == "512 bytes (512 bytes)")
        #expect(3071.formatted(style) == "3 kB (3,071 bytes)")
        #expect(4096.formatted(style) == "4 kB (4,096 bytes)")
        #expect(60000.formatted(style) == "60 kB (60,000 bytes)")
        #expect(65536.formatted(style) == "66 kB (65,536 bytes)")
        #expect(983748334.formatted(style) == "983.7 MB (983,748,334 bytes)")
        #expect(304828748323.formatted(style) == "304.83 GB (304,828,748,323 bytes)")
    }

    @Test func testDecimal() throws {
        let style = ByteCountFormatStyle(
            style: .decimal,
            allowedUnits: [.all],
            spellsOutZero: true,
            includesActualByteCount: false,
            locale: Locale(identifier: "en_US")
        )

        #expect(0.formatted(style) == "Zero kB")
        #expect(512.formatted(style) == "512 bytes")
        #expect(3071.formatted(style) == "3 kB")
        #expect(4096.formatted(style) == "4 kB")
        #expect(60000.formatted(style) == "60 kB")
        #expect(65536.formatted(style) == "66 kB")
        #expect(983748334.formatted(style) == "983.7 MB")
        #expect(304828748323.formatted(style) == "304.83 GB")
    }

    @Test func testMemory() throws {
        let style = ByteCountFormatStyle(
            style: .memory,
            allowedUnits: [.all],
            spellsOutZero: true,
            includesActualByteCount: false,
            locale: Locale(identifier: "en_US")
        )

        #expect(0.formatted(style) == "Zero kB")
        #expect(512.formatted(style) == "512 bytes")
        #expect(3071.formatted(style) == "3 kB")
        #expect(4096.formatted(style) == "4 kB")
        #expect(60000.formatted(style) == "59 kB")
        #expect(65536.formatted(style) == "64 kB")
        #expect(983748334.formatted(style) == "938.2 MB")
        #expect(304828748323.formatted(style) == "283.89 GB")
    }

    @Test func testBinary() throws {
        let style = ByteCountFormatStyle(
            style: .binary,
            allowedUnits: [.all],
            spellsOutZero: true,
            includesActualByteCount: false,
            locale: Locale(identifier: "en_US")
        )

        #expect(0.formatted(style) == "Zero kB")
        #expect(512.formatted(style) == "512 bytes")
        #expect(3071.formatted(style) == "3 kB")
        #expect(4096.formatted(style) == "4 kB")
        #expect(60000.formatted(style) == "59 kB")
        #expect(65536.formatted(style) == "64 kB")
        #expect(983748334.formatted(style) == "938.2 MB")
        #expect(304828748323.formatted(style) == "283.89 GB")
    }

}
