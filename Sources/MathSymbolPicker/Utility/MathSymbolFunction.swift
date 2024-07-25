//
//  MathSymbolFunction.swift
//  MathSymbolPicker
//
//  Created by christian on 25/07/24.
//

import Foundation

public struct MathSymbolFunction {}

extension MathSymbolFunction {

    static func localizedString(key: String) -> String {
        NSLocalizedString(key, bundle: .module, comment: "")
    }
}
