// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MyLibrary",
    platforms: [
        .macOS(.v15)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "MyLibrary",
            targets: ["MyLibrary"]
        ),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "MyLibrary",
//            exclude: [
//            ],
//            swiftSettings: [
//                .defaultIsolation(MainActor.self)
//            ]
        ),
        .testTarget(
            name: "MyLibraryTests",
            dependencies: ["MyLibrary"],
//            exclude: [
//            ],
            resources: [
                .copy("Bundle/BundleResources"),
                .copy("DirectoryCrawler/DirectoryCrawlerResources"),
            ],
//            swiftSettings: [
//                .defaultIsolation(MainActor.self)
//            ]
        ),
    ]
)
