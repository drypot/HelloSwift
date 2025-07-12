//
//  ActorLogger.swift
//  HelloSwift
//
//  Created by Kyuhyun Park on 11/20/24.
//

import Foundation

public actor ActorLogger {
    private var _log: [String]

    public init() {
        _log = []
    }

    public func append(_ message: String) {
        _log.append(message)
    }

    public func log() -> [String] {
        return _log
    }
}
