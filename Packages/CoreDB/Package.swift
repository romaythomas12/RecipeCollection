// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "CoreDB",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "CoreDB",
            targets: ["CoreDB"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/realm/realm-swift.git", from: "10.54.6")
     
    ],
    targets: [
        .target(
            name: "CoreDB",
            dependencies: [
                .product(name: "RealmSwift", package: "realm-swift")
            ]
        ),
        .testTarget(
            name: "CoreDBTests",
            dependencies: ["CoreDB"]
        )
    ]
)
