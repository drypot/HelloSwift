//
//  ResultTests.swift
//  HelloSwiftTests
//
//  Created by Kyuhyun Park on 11/9/24.
//

import Foundation
import Testing

// enum Result<Success, Failure> where Failure : Error, Success : ~Copyable
// https://developer.apple.com/documentation/swift/result

struct ResultTests {

    enum ParsingError: Error {
        case invalidString
    }

    func parse(_ string: String) throws -> Int {
        guard let parsed = Int(string) else {
            throw ParsingError.invalidString
        }
        return parsed
    }

    func parseAsResult(_ string: String) -> Result<Int, ParsingError> {
        guard let parsed = Int(string) else {
            return .failure(.invalidString)
        }
        return .success(parsed)
    }

    @Test func testException() throws {
        #expect(try parse("123") == 123)
        #expect(throws: ParsingError.invalidString) {
            try parse("xxx")
        }
    }

    @Test func testResultWithSwitch() throws {
        switch parseAsResult("123") {
        case .success(let value):
            #expect(value == 123)
        case .failure:
            fatalError()
        }

        switch parseAsResult("xxx") {
        case .success:
            fatalError()
        case .failure(let error):
            #expect(error == .invalidString)
        }
    }

    @Test func testResultWithIfCase() throws {
        if case .success(let value) = parseAsResult("123") {
            #expect(value == 123)
        } else {
            fatalError()
        }

        if case .failure(let error) = parseAsResult("xxx") {
            #expect(error == .invalidString)
        } else {
            fatalError()
        }
    }

    @Test func testResultEquality() throws {
        #expect(parseAsResult("123") == .success(123))
        #expect(parseAsResult("xxx") == .failure(.invalidString))
    }

    @Test func testConvertingExceptionToResult() throws {
        let result1 = Result {
            try parse("123")
        }.mapError { _ in ParsingError.invalidString }

        #expect(result1 == .success(123))

        let result2 = Result {
            try parse("xxx")
        }.mapError { _ in ParsingError.invalidString }

        #expect(result2 == .failure(.invalidString))
    }

    @Test func testConvertingResultToException() throws {
        #expect(try parseAsResult("123").get() == 123)

        #expect(throws: ParsingError.invalidString) {
            try parseAsResult("xxx").get()
        }
    }

    @Test func testMap() throws {
        let result1 = parseAsResult("123").map { "mapped \($0)" }

        #expect(result1 == .success("mapped 123"))

        let result2 = parseAsResult("xxx").map { "mapped \($0)" }

        #expect(result2 == .failure(.invalidString))
    }

    @Test func testNever() throws {

        // Never 는 Error 의 서브 타입이다.
        // Never 인스턴스는 임의로 만들 수 없다.
        // 함수가 리턴하지 않거나, 항상 success 를 리턴하는 Result 를 기술하기 위해 사용한다.

        func sub() -> Result<Int, Never> {
            return .success(10)
        }

        switch sub() {
        case .success(let value):
            #expect(value == 10)
        }
    }
}
