//
//  Extension+Array.swift
//  MathSymbolPicker
//
//  Created by christian on 25/07/24.
//

import Foundation

extension Array<String> {
    static func locale(for regionCode: String) -> String? {
        let languageCode = Locale(identifier: regionCode).language.languageCode?.identifier ?? "en"
        return Locale(identifier: languageCode + "_" + regionCode)
            .localizedString(forRegionCode: regionCode)
    }

    @available(*, deprecated, message: "")
    static var countriesNames: [String] {
        let isoCodes: [String] = [].countriesISOCodes
        var countrieNames: [String] = []
        for isoCode in isoCodes {
            if #available(macOS 14.0, *) {
                countrieNames.append(locale(for: isoCode)!)
            } else {
                // Fallback on earlier versions
            }
        }
        return countrieNames
    }

    @available(*, deprecated, message: "")
    static var countriesFlags: [String] {
        let flagBase = Unicode.Scalar("🇦").value - Unicode.Scalar("A").value
        var flags: [String] = []
        let isoCodes = Locale.isoRegionCodes
        for isoCode in isoCodes {
            let flag =
            isoCode
                    .uppercased()
                    .unicodeScalars
                    .compactMap({ Unicode.Scalar(flagBase + $0.value)?.description })
                    .joined()
            flags.append(flag)
        }
        flags.sort()
        return flags.unique
    }

    func filtered(_ searchText: String) -> [String] {
        return filter { $0.lowercased().contains(searchText.lowercased()) }
    }

    @available(
        *, deprecated, renamed: "Locale.isoRegionCodes",
        message: "try to bypass the problem with `Locale.Region.isoRegions`"
    )
    var countriesISOCodes: [String] {
        let isoCodes = Locale.isoRegionCodes.unique
        return (isoCodes)
    }

    var preferredLanguage: [String] {
        let preferredLanguage = Locale.preferredLanguages.unique
        print(preferredLanguage)
        return (preferredLanguage)
    }

    func emoji(_ value: Int) -> String {
        guard let scalar = UnicodeScalar(value) else { return "?" }
        return String(Character(scalar))
    }

    var unique: [String] {
        var uniqueValues: [String] = []
        forEach { item in
            guard !uniqueValues.contains(item) else { return }
            uniqueValues.append(item)
        }
        return uniqueValues
    }
}
