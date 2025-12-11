// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "Core",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Core",
            targets: ["Core"]
        )
    ],
    dependencies: [
        .package(path: "../CoreDB")
    ],
    targets: [
        // Main module target
        .target(
            name: "Core",
            dependencies: [
                "CoreDB"
            ],
        ),

        // Test target
        .testTarget(
            name: "CoreTests",
            dependencies: ["Core"]
        )
    ]
)
