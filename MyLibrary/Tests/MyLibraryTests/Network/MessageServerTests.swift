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
import MyLibrary

struct MessageServerTests {

    @Test func test() async throws {
        let port:UInt16 = 9090

        let serverManager = MessageServer(port: port)
        try await serverManager.start()

        let client = MessageClient(host: "localhost", port: port)
        client.start()

        do {
            let packet = await client.nextPacket()
            switch packet {
            case .data(let data):
                let message = String(data: data, encoding: .utf8)
                #expect(message == "hello")
            default:
                fatalError()
            }
        }

        do {
            let data = "good day".data(using: .utf8)!
            client.send(data)
        }

        do {
            let packet = await client.nextPacket()
            switch packet {
            case .data(let data):
                let message = String(data: data, encoding: .utf8)
                #expect(message == "good day")
            default:
                fatalError()
            }
        }

        client.stop()
        serverManager.stop()
    }

}
