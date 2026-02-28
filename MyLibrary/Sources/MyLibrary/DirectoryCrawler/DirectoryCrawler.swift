//
//  DirectoryCrawler.swift
//  MyLibrary
//
//  Created by Kyuhyun Park on 2/28/26.
//

import Foundation

public class Folder {
    public var name: String
    public var url: URL
    public var folders: [Folder]?

    public init(url: URL) {
        self.url = url
        self.name = url.lastPathComponent
    }
}

public struct DirectoryCrawler {
    public init() {}

    public func collectFiles(from root: URL) throws -> [URL] {
        let fileManager = FileManager.default
        var files: [URL] = []

        let keys: [URLResourceKey] = [.isRegularFileKey]
        let keySet = Set(keys)
        let options: FileManager.DirectoryEnumerationOptions = [.skipsHiddenFiles]

        let urls = try fileManager.contentsOfDirectory(
            at: root,
            includingPropertiesForKeys: keys,
            options: options
        )

        for url in urls {
            try autoreleasepool {
                let values = try url.resourceValues(forKeys: keySet)
                if values.isRegularFile == true {
                    files.append(url)
                }
            }
        }

        return files
    }

    public func collectFilesRecursively(from root: URL) throws -> [URL] {
        let fileManager = FileManager.default
        var files: [URL] = []

        let keys: [URLResourceKey] = [.isRegularFileKey]
        let keySet = Set(keys)
        let options: FileManager.DirectoryEnumerationOptions = [.skipsHiddenFiles]

        guard let enumerator = fileManager.enumerator(
            at: root,
            includingPropertiesForKeys: keys,
            options: options
        ) else { return [] }

        for case let url as URL in enumerator {
            try autoreleasepool {
                let values = try url.resourceValues(forKeys: keySet)
                if values.isRegularFile == true {
                    files.append(url)
                }
            }
        }

        return files
    }

    public func buildFolderTree(from root: URL) throws -> Folder {
        let keys: [URLResourceKey] = [.isDirectoryKey]
        let keySet = Set(keys)
        let options: FileManager.DirectoryEnumerationOptions = [.skipsHiddenFiles]

        func buildFolder(from url: URL) throws -> Folder {
            let fileManager = FileManager.default
            let folder = Folder(url: url)

            let urls = try fileManager.contentsOfDirectory(
                at: url,
                includingPropertiesForKeys: keys,
                options: options
            )

            for url in urls {
                try autoreleasepool {
                    let values = try url.resourceValues(forKeys: keySet)
                    if values.isDirectory == true {
                        let child = try buildFolder(from: url)
                        if folder.folders == nil {
                            folder.folders = [child]
                        } else {
                            folder.folders!.append(child)
                        }
                    }
                }
            }

            return folder
        }

        return try buildFolder(from: root)
    }
}
