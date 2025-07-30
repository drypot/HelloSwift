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

        // 이 간이 메시지 클래스들은 framing 처리를 안 해봐서;
        // hello 와 good day 가 붙어서 와 버릴 수 있다;
        // 그러면 테스트가 실패하고 행이 걸린다;
        // 나중에 수정해야;
        
        #expect((await client.receive()) == "hello")
        #expect((await client.receive()) == "good day")

        client.stop()
        server.stop()
    }

}
