// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "KhaltiCheckout",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(
            name: "KhaltiCheckout",
            targets: ["KhaltiCheckout"]
        ),
    ],
    dependencies: [
        // Add any external dependencies here if needed
    ],
    targets: [
        .target(
            name: "KhaltiCheckout",
            dependencies: [],
            path: "Sources/KhaltiCheckout",
            resources: [
                .process("Resources/CheckOut.storyboard")
            ]
        ),
        .testTarget(
            name: "KhaltiCheckoutTests",
            dependencies: ["KhaltiCheckout"],
            path: "Tests/KhaltiCheckoutTests"
        ),
    ],
    swiftLanguageVersions: [.v5]
)
