// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PopoverMathSymbolPicker",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v15),
        .macOS(.v13),
        .tvOS(.v15),
        .watchOS(.v8),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(name: "PopoverMathSymbolPicker", type: .dynamic, targets: ["PopoverMathSymbolPicker"])],
    targets: [
        .target(
            name: "PopoverMathSymbolPicker",
            path: "Sources/SymbolPicker",
            resources: [
                .process("Resources")
            ]),
        .testTarget(name: "PopoverMathSymbolPickerTests", dependencies: ["PopoverMathSymbolPicker"]),
        .testTarget(name: "PopoverMathSymbolPickerUITests", dependencies: ["PopoverMathSymbolPicker"])
    ]
)
