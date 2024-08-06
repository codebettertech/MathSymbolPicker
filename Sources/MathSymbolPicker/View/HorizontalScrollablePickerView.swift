//
//  HorizontalScrollablePickerView.swift
//  MathSymbolPicker
//
//  Created by christian on 04/08/24.
//

import SwiftUI

@available(macOS 14.0, *)
struct HorizontalScrollablePickerView: View {

    @State private var selection: Int = 0

    var body: some View {
        GeometryReader { geometry in
            ScrollView(.horizontal, showsIndicators: true) {
                LazyHStack {
                    Picker("", selection: $selection) {
                        ForEach(0 ..< 94, id: \.self) { _ in
                            Label(
                                title: { Text("All") },
                                icon: { Image(systemName: "pencil") }
                            )
                            .labelStyle(.titleOnly)
                            .padding()
                        }
                    }
                    .padding()
                    .frame(
                        width: geometry.size.width,
                        height: 56
                    )
                    .pickerStyle(.palette)
                }
                .frame(
                    width: .infinity,
                    height: 56
                )
            }
        }
    }
}
