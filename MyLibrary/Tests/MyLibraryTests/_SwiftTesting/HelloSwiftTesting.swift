//
//  HelloSwiftTesting.swift
//  MyLibrary
//
//  Created by Kyuhyun Park on 9/19/24.
//

import Testing
@testable import MyLibrary

struct HelloSwiftTesting {

    @Test func example() throws {
        #expect("abc" == "abc")
    }

}
