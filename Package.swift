// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftDiffPatch",
    products: [
        .library(
            name: "SwiftDiffPatch",
            targets: ["SwiftDiffPatch"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "SwiftDiffPatch",
            dependencies: []),
        .testTarget(
            name: "SwiftDiffPatchTests",
            dependencies: ["SwiftDiffPatch"]),
    ]
)
