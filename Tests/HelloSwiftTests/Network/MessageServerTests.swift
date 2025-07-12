//
//  MessageServerTests.swift
//  HelloSwiftTests
//
//  Created by Kyuhyun Park on 12/12/24.
//

import Foundation
import Testing
import Network
import os
import HelloSwift

struct MessageServerTests {

    @Test func test() async throws {
        let port:UInt16 = 9090

        let server = MessageServer(port: port)
        try server.start()

        let client = MessageClient(host: "localhost", port: port)
        client.start()

        await client.send("good day")

        #expect((await client.receive()) == "hello")
        #expect((await client.receive()) == "good day")

        client.stop()
        server.stop()
    }

}
