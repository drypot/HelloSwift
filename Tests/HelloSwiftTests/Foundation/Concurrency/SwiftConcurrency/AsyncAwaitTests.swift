//
//  AsyncAwaitTests.swift
//  HelloSwiftTests
//
//  Created by Kyuhyun Park on 11/10/24.
//

import Foundation
import Testing

struct AsyncAwaitTests {

    func fetchValue() async -> Int {
        return 10
    }

    @Test func testAsyncAwait() async throws {

        let value = await fetchValue()

        #expect(value == 10)
    }

}
