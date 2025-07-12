//
//  IntIDTests.swift
//  HelloSwiftTests
//
//  Created by Kyuhyun Park on 11/19/24.
//

import Foundation
import Testing
import HelloSwift

struct IntIDTests {

    @Test func test() throws {
        let id1 = IntID()
        let id2 = IntID()

        print(id1)
        print(id2)

        #expect(id1 != id2)
    }

}
