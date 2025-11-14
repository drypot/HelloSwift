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
        try await server.start()

        let client = MessageClientConnection(host: "localhost", port: port)
        try await client.start()

        do {
            let message = await client.receive()
            #expect(message == "hellox")
        }

        try await client.send("good day")

        do {
            let message = await client.receive()
            #expect(message == "good dayx")
        }

        client.stop()
        server.stop()
    }

}
