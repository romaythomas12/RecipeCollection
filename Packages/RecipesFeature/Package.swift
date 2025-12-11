// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "RecipesFeature",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "RecipesFeature",
            targets: ["RecipesFeature"]
        )
    ],
    dependencies: [
        .package(path: "../Core"),
        .package(path: "../CoreUI"),
    ],
    targets: [
        .target(
            name: "RecipesFeature",
            dependencies: [
                "Core",
                "CoreUI",
            ]
        ),
        .testTarget(
            name: "RecipesFeatureTests",
            dependencies: ["RecipesFeature"]
        )
    ]
)
