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
       
    ],
    targets: [
        .target(
            name: "KhaltiCheckout",
            dependencies: [],
            path: "Sources/KhaltiCheckout",
            sources: [
                "Khalti.swift",
                "Component",
                "Model",
                "Resources/ErrorType.swift",
                "Resources/KhaltiGlobal.swift",
                "Resources/OnMessageEvent.swift",
                "Resources/OnMessagePayload.swift",
                "Resources/Url.swift",
                "Resources/Extensions",
                "Service",
                "View/KhaltiCheckoutView.swift",
                "View/KhaltiPaymentViewController.swift",
                "ViewModel"
            ],
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
