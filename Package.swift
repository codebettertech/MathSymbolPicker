// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let resourcePath: String = "Resources"

let package = Package(
    name: "MathSymbolPicker",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v15),
        .macOS(.v13),
        .tvOS(.v15),
        .watchOS(.v8),
    ],
    products: [
        .library(name: "MathSymbolPicker", type: .dynamic, targets: ["MathSymbolPicker"])],
    targets: [
        .target(
            name: "MathSymbolPicker"),
        .testTarget(name: "MathSymbolPickerTests", dependencies: ["MathSymbolPicker"]),
        .testTarget(name: "MathSymbolPickerUITests", dependencies: ["MathSymbolPicker"])
    ]
)
