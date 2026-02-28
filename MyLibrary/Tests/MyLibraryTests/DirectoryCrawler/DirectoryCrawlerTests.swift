//
//  DirectoryCrawlerTests.swift
//  MyLibrary
//
//  Created by Kyuhyun Park on 5/15/24.
//

import Foundation
import Testing
import MyLibrary

/*
 Why does FileManager.enumerator use an absurd amount of memory?
 https://stackoverflow.com/questions/46383143/why-does-filemanager-enumerator-use-an-absurd-amount-of-memory
 */

struct DirectoryCrawlerTests {

    func resourceURL(_ path: String = "") -> URL {
        return Bundle.module.resourceURL!
            .appending(path: "DirectoryCrawlerResources")
            .appending(path: path)
    }

    @Test func testCollectFiles() throws {
        let root = resourceURL()
        let files = try! DirectoryCrawler().collectFiles(from: root)
        let results = files.map { url in
            url.path.replacingOccurrences(of: root.path, with: "")
                .trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        }.sorted()

        #expect(results == [
            "dummy1.txt",
            "dummy2.txt"
        ])
    }

    @Test func testCollectFilesRecursively() throws {
        let root = resourceURL()
        let files = try! DirectoryCrawler().collectFilesRecursively(from: root)
        let results = files.map { url in
            url.path.replacingOccurrences(of: root.path, with: "")
                .trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        }.sorted()

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
        let root = resourceURL()
        let result = try! DirectoryCrawler().buildFolderTree(from: root)

        #expect(result.name == "DirectoryCrawlerResources")
        #expect(result.folders!.count == 1)
        #expect(result.folders![0].name == "Sub1")
        #expect(result.folders![0].folders!.count == 2)
        #expect(result.folders![0].folders![0].name == "Sub2")
        #expect(result.folders![0].folders![1].name == "Sub3")
    }
}
