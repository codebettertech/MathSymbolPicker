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
    public static let shared = MathSymbol()
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

    private init() {
        allSymbols = Self.fetchSymbols(fileName: "sfsymbol")
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
}
