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

    func resourceURL(_ path: String = "") -> URL {
        return Bundle.module.resourceURL!
            .appending(path: "DirectoryEnumeratorResources")
            .appending(path: path)
    }

    @Test func testEnumerateFiles() throws {
        let fileManager = FileManager.default
        let rootURL = resourceURL()
        var fileURLs = [URL]()

        let keys: [URLResourceKey] = [.isRegularFileKey]
        let keySet = Set(keys)
        let options: FileManager.DirectoryEnumerationOptions = [.skipsHiddenFiles]

        let urls = try fileManager.contentsOfDirectory(
            at: rootURL,
            includingPropertiesForKeys: keys,
            options: options
        )

        for url in urls {
            try autoreleasepool {
                let values = try url.resourceValues(forKeys: keySet)
                if values.isRegularFile == true {
                    fileURLs.append(url)
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
        let rootURL = resourceURL()
        var fileURLs = [URL]()

        let keys: [URLResourceKey] = [.isRegularFileKey]
        let keySet = Set(keys)
        let options: FileManager.DirectoryEnumerationOptions = [.skipsHiddenFiles]

        guard let enumerator = FileManager.default.enumerator(
            at: rootURL,
            includingPropertiesForKeys: keys,
            options: options
        ) else { return }

        for case let url as URL in enumerator {
            try autoreleasepool {
                let values = try url.resourceValues(forKeys: keySet)
                if values.isRegularFile == true {
                    fileURLs.append(url)
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

    @Test func testBuildFolderTree() throws {
        class Folder {
            let name: String
            let url: URL
            var children: [Folder]?

            init(url: URL) {
                self.url = url
                self.name = url.lastPathComponent
            }
        }

        let rootURL = resourceURL()

        let keys: [URLResourceKey] = [.isDirectoryKey]
        let keySet = Set(keys)
        let options: FileManager.DirectoryEnumerationOptions = [.skipsHiddenFiles]

        func buildFolderNode(from url: URL) throws -> Folder {
            let fileManager = FileManager.default
            let folder = Folder(url: url)

            let urls = try fileManager.contentsOfDirectory(
                at: url,
                includingPropertiesForKeys: Array(keySet),
                options: options
            )

            for url in urls {
                try autoreleasepool {
                    let values = try url.resourceValues(forKeys: keySet)
                    if values.isDirectory == true {
                        let childFolder = try buildFolderNode(from: url)
                        if folder.children == nil {
                            folder.children = [childFolder]
                        } else {
                            folder.children!.append(childFolder)
                        }
                    }
                }
            }

            return folder
        }

        let result = try buildFolderNode(from: rootURL)

        #expect(result.name == "DirectoryEnumeratorResources")
        #expect(result.children!.count == 1)
        #expect(result.children![0].name == "Sub1")
        #expect(result.children![0].children!.count == 2)
        #expect(result.children![0].children![0].name == "Sub2")
        #expect(result.children![0].children![1].name == "Sub3")
    }
}
