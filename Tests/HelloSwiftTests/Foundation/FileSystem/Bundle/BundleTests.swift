//
//  BundleTests.swift
//  HelloSwiftTesting
//
//  Created by drypot on 2022/10/02.
//

import Foundation
import Testing

fileprivate func stringToHex(_ string: String) -> String {
    return string.utf8.map { String(format: "%02x", $0) }.joined(separator: " ")
}

class BundleTests {

    @Test(.disabled()) func weCanDumpTextFile() throws {
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: "bundle-test-fixture", withExtension: "txt") else {
            fatalError()
        }

        let fileContent = try String(contentsOf: url, encoding: .utf8)
        let stringToCompare = "Hello, world!\n"

        //fileContent = fileContent.replacingOccurrences(of: "\r\n", with: "\n")

        #expect(fileContent == stringToCompare)
        #expect(stringToHex(fileContent) == "48 65 6c 6c 6f 2c 20 77 6f 72 6c 64 21 0a")
    }
    
}
