//
//  OptionSetTests.swift
//  HelloSwiftTests
//
//  Created by Kyuhyun Park on 10/25/24.
//

import Testing

struct OptionSetTests {

    // OptionSet is protocol

    struct FormatOptions: OptionSet  {
        let rawValue: Int

        static let withFullDate = FormatOptions(rawValue: 1 << 0)
        static let withFullTime = FormatOptions(rawValue: 1 << 1)
        static let withYear = FormatOptions(rawValue: 1 << 2)
        static let withMonth = FormatOptions(rawValue: 1 << 3)
    }

    @Test func testOptionSet() throws {
        var options: FormatOptions = [.withFullDate, .withFullTime]

        #expect(options.contains(.withFullDate) == true)
        #expect(options.contains(.withFullTime) == true)
        #expect(options.contains(.withYear) == false)

        options.insert(.withYear)

        #expect(options.contains(.withYear) == true)
    }

}
