// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "WolfPubSub",
    platforms: [
        .iOS(.v9), .macOS(.v10_13), .tvOS(.v11)
    ],
    products: [
        .library(
            name: "WolfPubSub",
            type: .dynamic,
            targets: ["WolfPubSub"]),
        ],
    dependencies: [
        .package(url: "https://github.com/wolfmcnally/WolfConcurrency", from: "3.0.0"),
        .package(url: "https://github.com/wolfmcnally/WolfFoundation", from: "5.0.0"),
    ],
    targets: [
        .target(
            name: "WolfPubSub",
            dependencies: [
                "WolfConcurrency",
                "WolfFoundation"
        ])
        ]
)
