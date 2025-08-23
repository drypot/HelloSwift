//
//  NSErrorTest.swift
//  HelloSwiftTesting
//
//  Created by Kyuhyun Park on 10/10/24.
//

import Foundation
import Testing

// Swift Error Handling Done Right: Overcoming the Objective-C Error Legacy
// https://www.fline.dev/swift-error-handling-done-right-overcoming-the-objective-c-error-legacy/

struct NSErrorTest {

    let url1 = URL(fileURLWithPath: "/non-existent")
    let url2 = URL(fileURLWithPath: "/someLocation")

    @Test func testNSErrorProperties() {
        var log: NSError! = nil

        do {
            try FileManager.default.moveItem(at: url1, to: url2)
        } catch let error as NSError {
            log = error
        } catch {
        }

        #expect(log.domain == NSCocoaErrorDomain)
        #expect(log.code == NSFileNoSuchFileError)
        #expect(log.userInfo[NSUnderlyingErrorKey] != nil)
        #expect(log.userInfo[NSURLErrorKey] as? URL == url1)
        #expect(log.userInfo[NSFilePathErrorKey] as? String == "/non-existent")
        #expect(log.userInfo["NSSourceFilePathErrorKey"] as? String == "/non-existent")
        #expect(log.userInfo["NSDestinationFilePath"] as? String == "/someLocation")
    }
    
    @Test func testNSErrorPatternMatching() {
        var log = ""

        do {
            try FileManager.default.moveItem(at: url1, to: url2)
        } catch CocoaError.fileNoSuchFile {
            log = "fileNoSuchFile"
        } catch let error as NSError {
            log = "Unexpected nserror: \(error)"
        } catch {
            log = "Unexpected error: \(error)"
        }

        #expect(log == "fileNoSuchFile")
    }
    
    @Test func tesCustomeNSError() {

        func divide(a: Double, b: Double) throws -> Double {
            if b == 0.0 {
                throw NSError(
                    domain: "CustomErrorDomain",
                    code: 5001,
                    userInfo: ["ErrorType": "DivideByZeroError"]
                )
            }
            return a / b
        }

        var log = ""

        do{
            let _ = try divide(a: 1, b: 0)
        } catch let error as NSError {
            log = "error: \(error.domain) \(error.code)"
        } catch let error {
            log = "Unexpected error: \(error)"
        }

        #expect(log == "error: CustomErrorDomain 5001")
    }

    
}
