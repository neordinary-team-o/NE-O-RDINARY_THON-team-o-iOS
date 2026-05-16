// swift-tools-version: 6.0
import PackageDescription

#if TUIST
    import ProjectDescription

    let packageSettings = PackageSettings(
        // Customize the product types for specific package product
        // Default is .staticFramework
        // productTypes: ["Alamofire": .framework,]
        productTypes: [:],
        baseSettings: .settings(configurations: [
            .debug(name: "Debug"),
            .debug(name: "Dev"),
            .debug(name: "Prod"),
            .release(name: "Release")
        ])
    )
#endif

let package = Package(
    name: "App",
    dependencies: [
        .package(url: "https://github.com/exyte/PopupView", .upToNextMajor(from: "4.1.17")),
        .package(url: "https://github.com/Little-tale/SwiftImageCompressor.git", .upToNextMajor(from: "0.0.3")),
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.11.1")),
        .package(url: "https://github.com/SwiftyBeaver/SwiftyBeaver.git", .upToNextMajor(from: "2.1.1")),
        .package(url: "https://github.com/onevcat/Kingfisher.git", .upToNextMajor(from: "8.9.0"))
        // Add your own dependencies here:
        // .package(url: "https://github.com/Alamofire/Alamofire", from: "5.0.0"),
        // You can read more about dependencies here: https://docs.tuist.io/documentation/tuist/dependencies
    ]
)
