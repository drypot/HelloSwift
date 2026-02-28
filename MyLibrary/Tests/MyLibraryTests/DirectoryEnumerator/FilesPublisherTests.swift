//
//  FilesPublisherTests.swift
//  HelloSwift
//
//  Created by Kyuhyun Park on 5/15/24.
//

import Foundation
import Combine
import Testing

fileprivate struct FilesPublisher: Publisher {
    public typealias Output = URL
    public typealias Failure = Never
    let url: URL

    public init(url: URL) {
        self.url = url
    }

    public func receive<S: Subscriber>(subscriber: S) where S.Input == Output, S.Failure == Failure {
        let subscription = Subscription(url: url, subscriber: subscriber)
        subscriber.receive(subscription: subscription)
    }
}

fileprivate extension FilesPublisher {
    final class Subscription<S: Subscriber>: Combine.Subscription where S.Input == Output, S.Failure == Failure {

        private let enumerator: FileManager.DirectoryEnumerator?
        private var subscriber: S?

        init(url: URL, subscriber: S) {
            self.subscriber = subscriber
            self.enumerator = FileManager.default.enumerator(
                at: url,
                includingPropertiesForKeys: [.isRegularFileKey],
                options: [.skipsHiddenFiles]
            )
        }

        func request(_ demand: Subscribers.Demand) {
            guard let enumerator else {
                subscriber?.receive(completion: .finished)
                return
            }

            do {
                var _continue = true
                var demand = demand
                let resourceKeys: Set<URLResourceKey> = [.isRegularFileKey]
                while let subscriber = subscriber, demand > 0, _continue {
                    try autoreleasepool {
                        guard let fileURL = enumerator.nextObject() as? URL else {
                            subscriber.receive(completion: .finished)
                            _continue = false
                            return
                        }
                        let resourceValues = try fileURL.resourceValues(forKeys: resourceKeys)
                        if resourceValues.isRegularFile! {
                            demand -= 1
                            demand += subscriber.receive(fileURL)
                        }
                    }
                }
            }
            catch {
                //print("Error getting resource values for \(fileURL): \(error)")
                subscriber?.receive(completion: .finished)
            }
        }

        func cancel() {
            subscriber = nil
        }
    }
}

struct FilesPublisherTests {

    func resourceURL(_ path: String = "") -> URL {
        return Bundle.module.resourceURL!
            .appending(path: "DirectoryEnumeratorResources")
            .appending(path: path)
    }

    @Test func testFilesPublisher() throws {
        let url = resourceURL()
        var resultURLs = [URL]()

        let _ = FilesPublisher(url: url).sink { url in
            resultURLs.append(url)
        }

        let files = resultURLs
            .map { $0.absoluteString }
            .compactMap {
                guard let range = $0.range(of: "Fixtures") else { return nil }
                return String($0[range.upperBound...])
            }
            .sorted(by: <)

        #expect(files == [
            "/Sub1/Sub2/dummy5.txt",
            "/Sub1/Sub2/dummy6.txt",
            "/Sub1/Sub3/dummy7.txt",
            "/Sub1/Sub3/dummy8.txt",
            "/Sub1/dummy3.txt",
            "/Sub1/dummy4.txt",
            "/dummy1.txt",
            "/dummy2.txt"
        ])
    }

}
