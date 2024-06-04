// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WWPulseLayer",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(name: "WWPulseLayer", targets: ["WWPulseLayer"]),
    ],
    targets: [
        .target(name: "WWPulseLayer", resources: [.copy("Privacy")]),
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
