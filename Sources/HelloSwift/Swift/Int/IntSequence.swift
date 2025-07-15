//
//  IntSequence.swift
//  HelloSwift
//
//  Created by Kyuhyun Park on 7/15/25.
//

import Foundation

public struct IntSequence: Sequence, IteratorProtocol {
    private var current: Int

    public init(start: Int = 0) {
        self.current = start
    }

    public mutating func next() -> Int? {
        defer { current += 1 }
        return current
    }

    public func makeIterator() -> Self {
        return self
    }
}
