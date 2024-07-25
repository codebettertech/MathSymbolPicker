//
//  MathSymbol.swift
//  MathSymbolPicker
//
//  Created by CodeBetter Inc. on 25/07/24.
//

import Foundation

protocol MathSymbolDelegate: NSObject {
    static var shared: MathSymbolDelegate { get set }
    func didSelectSymbol(_ symbol: String)

    /// Array of all available symbol in a  Resource files
    static func fetchSymbols(fileName: String) -> [String]

    var selectedSymbol: String? { get }

    /// Filter closure that checks each symbol name string should be included.
    var filter: ((String) -> Bool)? { get set }

    /// Array of the symbol name strings to be displayed.
    var symbols: [String] { get set }

    /// Array of all available symbol name strings.
    var allSymbols: [String] { get }

    /// Array of all available symbol in a  XcodeCore  library
    static func getCoreLibrarySymbols() -> [String]
}

/// Simple singleton class for providing symbols list per platform availability.
public class MathSymbol: @unchecked Sendable {
    /// Singleton instance.
    public static let shared = MathSymbol.init()
    /// Filter closure that checks each symbol name string should be included.
    public var filter: ((String) -> Bool)? {
        didSet {
            if let filter {
                symbols = allSymbols.filter(filter)
            } else {
                symbols = allSymbols
            }
        }
    }

    /// Array of the symbol name strings to be displayed.
    private(set) var symbols: [String] = []

    /// Array of all available symbol name strings.
    private var allSymbols: [String] = []
    private var allSymbolsName: [String] = []


    public convenience init(symbols: [String]? = nil) {
        self.init()
    }

    private init() {
        self.allSymbols = [_].countriesFlags.sorted()
        self.allSymbolsName = [_].countriesNames.sorted()
        self.symbols = self.allSymbols
    }



    private func inititializer() {
        if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, visionOS 1.0, *) {
            self.allSymbols = Self.fetchSymbols(fileName: "sfsymbol5")
        } else if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
            self.allSymbols = Self.fetchSymbols(fileName: "sfsymbol4")
        } else {
            allSymbols = Self.fetchSymbols(fileName: "sfsymbol")
        }
        symbols = allSymbols
    }

    private static func fetchSymbols(fileName: String) -> [String] {
        guard let path = Bundle.module.path(forResource: fileName, ofType: "txt"),
              let content = try? String(contentsOfFile: path) else {
            #if DEBUG
                assertionFailure("[SymbolPicker] Failed to load bundle resource file.")
            #endif
            return []
        }
        return content
            .split(separator: "\n")
            .map { String($0) }
    }


    private func getCoreLibrarySymbols() -> [String] {
        var allSymbols = [String]()
        if let bundle = Bundle(identifier: "com.apple.CoreGlyphs"),
           let resourcePath = bundle.path(forResource: "name_availability", ofType: "plist"),
           let plist = NSDictionary(contentsOfFile: resourcePath),
           let plistSymbols = plist["symbols"] as? [String: String] {
            // Get all symbol names
            allSymbols = Array(plistSymbols.keys)
        }
        return allSymbols
    }
}
