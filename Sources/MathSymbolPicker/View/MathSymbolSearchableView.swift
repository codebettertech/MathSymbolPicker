//
//  MathSymbolSearchableView.swift
//  MathSymbolPicker
//
//  Created by CodeBetter Inc. on 25/07/24.
//

import SwiftUI

struct MathSymbolSearchableView: View {
    @Binding private var searchText: String

    init(searchText: Binding<String>) {
        _searchText = searchText
    }

    var body: some View {
        HStack {
            MathSymbolSearchableField(MathSymbolFunction.localizedString(key: "search_placeholder"), text: $searchText)
        }.padding()
        Divider()
    }
}

#Preview("MathSymbolSearchableView") {
    struct Preview: View {
        @State private var searchText = ""
        var body: some View {
            MathSymbolSearchableView(searchText: $searchText)
        }
    }
    return Preview()
}

