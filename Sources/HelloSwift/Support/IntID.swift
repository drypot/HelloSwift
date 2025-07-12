//
//  IntID.swift
//  HelloSwift
//
//  Created by Kyuhyun Park on 11/19/24.
//

import Foundation
import os

public struct IntIDGenerator: Sendable {

    private let currentID: OSAllocatedUnfairLock<Int>

    init(start: Int = 0) {
        currentID = OSAllocatedUnfairLock<Int>(initialState: start - 1)
    }

    func nextID() -> Int {
        currentID.withLock {
            $0 += 1
            return $0
        }
    }

}

public struct IntID: Identifiable, Equatable, Hashable {

    private static let idGenerator = IntIDGenerator()

    public let id: Int

    public init() {
        id = Self.idGenerator.nextID()
    }

}
