//
//  NetworkPacket.swift
//  HelloSwift
//
//  Created by Kyuhyun Park on 11/15/25.
//

import Foundation
import Network

public enum NetworkPacket: Sendable {
    case data(data: Data)
    case error(error: NWError)
    case completed
}

public actor NetworkPacketQueue {
    private var queue: [NetworkPacket] = []
    private var waiting: [CheckedContinuation<NetworkPacket, Never>] = []

    func enqueue(_ packet: NetworkPacket) {
        if let continuation = waiting.first {
            waiting.removeFirst()
            continuation.resume(returning: packet)
        } else {
            queue.append(packet)
        }
    }

    func dequeue() async -> NetworkPacket {
        if !queue.isEmpty {
            return queue.removeFirst()
        }

        return await withCheckedContinuation { continuation in
            waiting.append(continuation)
        }
    }

}
