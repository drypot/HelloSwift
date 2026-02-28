//
//  FileEnumeratorTests.swift
//  HelloSwift
//
//  Created by Kyuhyun Park on 5/15/24.
//

import Foundation
import Testing

fileprivate struct Files: Sequence  {

    static let keys: [URLResourceKey] = [.isRegularFileKey, .isDirectoryKey]
    static let keySet: Set<URLResourceKey> = Set(keys)
    static let options: FileManager.DirectoryEnumerationOptions = [.skipsHiddenFiles]

    private let rootURLs: [URL]

    public init(urls: [URL]) {
        self.rootURLs = urls
    }

    public init(url: URL) {
        self.rootURLs = [url]
    }

    public func makeIterator() -> Self.Iterator {
        return Iterator(urls: self.rootURLs)
    }

    public struct Iterator: IteratorProtocol {
        private var rootURLs: [URL]
        private var enumerator: FileManager.DirectoryEnumerator?

        init(urls: [URL]) {
            self.rootURLs = urls
        }

        public mutating func next() -> URL? {
            // FileManager enumerator 가 기본적으로 deep 하기 때문에
            // 1차원 urls에 대해서만 루프를 돌리면 된다.
            // 내가 직접 트리를 타고 내려갈 필요는 없다.
            do {
                if let enumerator {
                    if let url = enumerator.nextObject() as? URL {
                        let values = try url.resourceValues(forKeys: keySet)
                        if values.isRegularFile == true {
                            return url
                        }
                        return next()
                    } else {
                        self.enumerator = nil
                        return next()
                    }
                } else {
                    if rootURLs.isEmpty {
                        return nil
                    } else {
                        let url = rootURLs.removeFirst()
                        let values = try url.resourceValues(forKeys: keySet)
                        if values.isRegularFile == true {
                            return url
                        }
                        if values.isDirectory == true {
                            enumerator = FileManager.default.enumerator(
                                at: url,
                                includingPropertiesForKeys: keys,
                                options: options
                            )
                            return next()
                        }
                        return nil
                    }
                }
            } catch {
                return nil
            }
        }
    }
}

struct FileEnumeratorTests {

    func resourceURL(_ path: String = "") -> URL {
        return Bundle.module.resourceURL!
            .appending(path: "DirectoryCrawlerResources")
            .appending(path: path)
    }

    @Test func testAll() throws {
        let rootURL = resourceURL()

        let files = Files(url: rootURL)
            .map { url in
                url.path.replacingOccurrences(of: rootURL.path, with: "")
                    .trimmingCharacters(in: CharacterSet(charactersIn: "/"))
            }
            .sorted()

        #expect(files == [
            "Sub1/Sub2/dummy5.txt",
            "Sub1/Sub2/dummy6.txt",
            "Sub1/Sub3/dummy7.txt",
            "Sub1/Sub3/dummy8.txt",
            "Sub1/dummy3.txt",
            "Sub1/dummy4.txt",
            "dummy1.txt",
            "dummy2.txt"
        ])
    }

    @Test func testSub1() throws {
        let rootURL = resourceURL("Sub1")

        let files = Files(url: rootURL)
            .map { url in
                url.path.replacingOccurrences(of: rootURL.path, with: "")
                    .trimmingCharacters(in: CharacterSet(charactersIn: "/"))
            }
            .sorted()

        #expect(files == [
            "Sub2/dummy5.txt",
            "Sub2/dummy6.txt",
            "Sub3/dummy7.txt",
            "Sub3/dummy8.txt",
            "dummy3.txt",
            "dummy4.txt",
        ])
    }

    @Test func testSub1Dummy1() throws {
        let rootURL = resourceURL()

        let urls = [
            rootURL.appending(path: "dummy1.txt"),
            rootURL.appending(path: "Sub1")
        ]

        let files = Files(urls: urls)
            .map { url in
                url.path.replacingOccurrences(of: rootURL.path, with: "")
                    .trimmingCharacters(in: CharacterSet(charactersIn: "/"))
            }
            .sorted()

        #expect(files == [
            "Sub1/Sub2/dummy5.txt",
            "Sub1/Sub2/dummy6.txt",
            "Sub1/Sub3/dummy7.txt",
            "Sub1/Sub3/dummy8.txt",
            "Sub1/dummy3.txt",
            "Sub1/dummy4.txt",
            "dummy1.txt",
        ])
    }

}
