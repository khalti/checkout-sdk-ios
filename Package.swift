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
        )
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "KhaltiCheckout",
            dependencies: [],
            path: "Sources",
            exclude: [
                "Core/Resources/CheckOut.storyboard"
            ],
            sources: [
                "Core",
                "KhaltiCheckout/Khalti.swift",
                "KhaltiCheckout/Component",
                "KhaltiCheckout/View/KhaltiCheckoutView.swift",
                "KhaltiCheckout/View/KhaltiPaymentViewController.swift",
                "KhaltiCheckout/ViewModel"
            ],
            resources: [
                .process("Core/Resources/CheckOut.storyboard")
            ]
        ),
        .testTarget(
            name: "KhaltiCheckoutTests",
            dependencies: ["KhaltiCheckout"],
            path: "Tests/KhaltiCheckoutTests"
        )
    ],
    swiftLanguageVersions: [.v5]
)
