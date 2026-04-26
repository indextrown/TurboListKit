// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TurboListKit",
    platforms: [.iOS(.v13), .macOS(.v10_15)],
    products: [
        .library(
            name: "TurboListKit",
            targets: ["TurboListKit"]
        ),
    ],
    dependencies: [
//        .package(
//            url: "https://github.com/apple/swift-syntax.git",
//            from: "509.0.0"
//        ),
        .package(url: "https://github.com/swiftlang/swift-syntax.git", "509.0.0"..<"603.0.0"),
        .package(
            url: "https://github.com/ra1028/DifferenceKit.git",
            .upToNextMajor(from: "1.0.0")
        ),
    ],
    targets: [
        .target(
            name: "TurboListKit",
            dependencies: [
                "DifferenceKit"
            ],
            path: "Sources/TurboListKit"
        ),
        .testTarget(
            name: "TurboListKitTests",
            dependencies: ["TurboListKit"],
            path: "Tests/TurboListKitTests"
        ),
    ],
//    swiftLanguageModes: [.v6]
    swiftLanguageVersions: [.v5]
)
