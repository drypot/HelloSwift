//
//  AsResult.swift
//  HelloSwiftUI
//
//  Created by Kyuhyun Park on 12/16/24.
//

import Foundation
import Combine

// Error Handling with Combine and SwiftUI
// https://peterfriese.dev/blog/2022/swiftui-combine-networking-errorhandling/

// The power of extensions in Swift
// https://www.swiftbysundell.com/articles/the-power-of-extensions-in-swift/#specializing-generics

public extension Publisher {
    func asResult() -> AnyPublisher<Result<Output, Failure>, Never> {
    self
      .map(Result.success)
      .catch { error in
        Just(.failure(error))
      }
      .eraseToAnyPublisher()
  }
}
