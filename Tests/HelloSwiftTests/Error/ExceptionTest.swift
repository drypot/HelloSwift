//
//  ExceptionTest.swift
//  HelloSwiftTesting
//
//  Created by Kyuhyun Park on 10/8/24.
//

import Foundation
import Testing

// Mastering macOS programming-Packt Publishing (2017), 12장,

// an Error type in Swift is literally anything you want it to be;
// you simply create a struct, or a class, or an enum, and
// declare it to conform to the Error protocol

struct ExceptionTest {
    
    enum MathError: Error, Equatable {
        case divideByZeroError
        case negativeNumberError
        case lousyNumberError(objection: String)
    }

    func divide(_ a: Double, by b: Double) throws -> Double {
        if b < 0.0 {
            throw MathError.negativeNumberError
        }
        if b == 0.0 {
            throw MathError.divideByZeroError
        }
        return a / b
    }

    @Test func testSuccess() throws {
        var result: Double?

        do {
            result = try divide(10, by: 2)
        } catch {
            result = nil
        }

        #expect(result == 5)
    }
    
    @Test func testThrows() throws {
        #expect(throws: Never.self) {
            try divide(10, by: 2)
        }

        #expect(throws: MathError.divideByZeroError) {
            try divide(10, by: 0.0)
        }
    }
    
    @Test func testCatch() throws {
        var message: String?
        
        do {
            let _ = try divide(10, by: 0)
            message = "ok"
        } catch {
            message = "error"
        }
        
        #expect(message == "error")
    }

    @Test func testCatchCases() throws {
        var message: String?
        
        do {
            let _ = try divide(10, by: -10)
            message = "ok"
        } catch MathError.divideByZeroError {
            message = "divide by zero"
        } catch MathError.negativeNumberError {
            message = "negative number"
        }
        
        #expect(message == "negative number")
    }
    
    @Test func testTryBang() throws {
        let result: Double

        result = try! divide(10, by: 2)

        #expect(result == 5)
    }
    
    @Test func testTryOptional() throws {
        do {
            let result: Double? = try? divide(10, by: 2)

            #expect(result == 5)
        }
        
        do {
            let result: Double? = try? divide(10, by: 0)
            
            #expect(result == nil)
        }
    }
}
