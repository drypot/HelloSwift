//
//  EnumerateFilesTests.swift
//  HelloSwift
//
//  Created by Kyuhyun Park on 5/15/24.
//

import Foundation
import Testing

/*
 Why does FileManager.enumerator use an absurd amount of memory?
 https://stackoverflow.com/questions/46383143/why-does-filemanager-enumerator-use-an-absurd-amount-of-memory
 */

struct EnumerateFilesTests {

    func fixtureURL(_ path: String = "") -> URL {
        return Bundle.module.resourceURL!
            .appending(path: "DirectoryEnumeratorFixtures")
            .appending(path: path)
    }

    @Test func testEnumerateFiles() throws {
        let fileManager = FileManager.default
        let rootURL = fixtureURL()
        var fileURLs = [URL]()

        let keys: [URLResourceKey] = [.isRegularFileKey]
        let keySet = Set(keys)
        let options: FileManager.DirectoryEnumerationOptions = [.skipsHiddenFiles]

        let items = try fileManager.contentsOfDirectory(
            at: rootURL,
            includingPropertiesForKeys: keys,
            options: options
        )

        for case let item in items {
            try autoreleasepool {
                let values = try item.resourceValues(forKeys: keySet)
                if values.isRegularFile == true {
                    fileURLs.append(item)
                }
            }
        }

        let results = fileURLs
            .map { url in
                url.path.replacingOccurrences(of: rootURL.path, with: "")
                    .trimmingCharacters(in: CharacterSet(charactersIn: "/"))
            }
            .sorted()

        #expect(results == [
            "dummy1.txt",
            "dummy2.txt"
        ])
    }

    @Test func testEnumerateFilesDeeply() throws {
        let rootURL = fixtureURL()
        var fileURLs = [URL]()

        let keys: [URLResourceKey] = [.isRegularFileKey]
        let keySet = Set(keys)
        let options: FileManager.DirectoryEnumerationOptions = [.skipsHiddenFiles]

        guard let enumerator = FileManager.default.enumerator(
            at: rootURL,
            includingPropertiesForKeys: keys,
            options: options
        ) else { return }

        for case let fileURL as URL in enumerator {
            try autoreleasepool {
                let values = try fileURL.resourceValues(forKeys: keySet)
                if values.isRegularFile == true {
                    fileURLs.append(fileURL)
                }
            }
        }

        let results = fileURLs
            .map { url in
                url.path.replacingOccurrences(of: rootURL.path, with: "")
                    .trimmingCharacters(in: CharacterSet(charactersIn: "/"))
            }
            .sorted()

        #expect(results == [
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

    @Test func testBuildingDirectoryTree() throws {
        class Folder {
            let name: String
            let url: URL
            var children: [Folder] = []

            init(url: URL) {
                self.url = url
                self.name = url.lastPathComponent
            }
        }

        let rootURL = fixtureURL()

        let keys: [URLResourceKey] = [.isDirectoryKey]
        let keySet = Set(keys)
        let options: FileManager.DirectoryEnumerationOptions = [.skipsHiddenFiles]

        func buildDirectoryTree(at url: URL) throws -> Folder {
            let fileManager = FileManager.default
            let node = Folder(url: url)

            let items = try fileManager.contentsOfDirectory(
                at: url,
                includingPropertiesForKeys: Array(keySet),
                options: options
            )

            for item in items {
                try autoreleasepool {
                    let values = try item.resourceValues(forKeys: keySet)
                    if values.isDirectory == true {
                        let childNode = try buildDirectoryTree(at: item)
                        node.children.append(childNode)
                    }
                }
            }

            return node
        }

        let result = try buildDirectoryTree(at: rootURL)

        #expect(result.name == "DirectoryEnumeratorFixtures")
        #expect(result.children.count == 1)
        #expect(result.children[0].name == "Sub1")
        #expect(result.children[0].children.count == 2)
        #expect(result.children[0].children[0].name == "Sub2")
        #expect(result.children[0].children[1].name == "Sub3")
    }
}
