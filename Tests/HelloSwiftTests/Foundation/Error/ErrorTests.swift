//
//  ErrorTests.swift
//  HelloSwiftTests
//
//  Created by Kyuhyun Park on 4/27/25.
//

import Foundation
import Testing

// protocol Error : Sendable
// https://developer.apple.com/documentation/swift/error

struct ErrorTests {

    struct XMLParsingError: Error {

        enum ErrorKind {
            case invalidCharacter
            case mismatchedTag
            case internalError
        }

        let line: Int
        let column: Int
        let kind: ErrorKind
    }

    struct XMLDoc {
    }

    func parse(_ source: String) throws -> XMLDoc {
        throw XMLParsingError(line: 19, column: 5, kind: .mismatchedTag)
    }

    @Test func test() throws {
        var errorMessage = ""

        do {
            let _ = try parse("")
        } catch let e as XMLParsingError {
            errorMessage = "Parsing error: \(e.kind) \(e.line) \(e.column)"
        } catch {
            errorMessage = "Other error: \(error)"
        }

        #expect(errorMessage == "Parsing error: mismatchedTag 19 5")
    }

}
