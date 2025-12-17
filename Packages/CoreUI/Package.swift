// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "CoreUI",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "CoreUI",
            targets: ["CoreUI"]
        )
    ],
    targets: [
        .target(
            name: "CoreUI",
        )
    ]
)
