//
//  MathSymbolSearchableField.swift
//  MathSymbolPicker
//
//  Created by Austin Condiff on 11/2/23.
//

import Combine
import SwiftUI

struct MathSymbolSearchableField<LeadingAccessories: View, TrailingAccessories: View>: View {
    @Environment(\.colorScheme)
    var colorScheme

    @Environment(\.controlActiveState)
    private var controlActive

    @FocusState private var isFocused: Bool

    var label: String

    @Binding private var text: String

    let axis: Axis

    let leadingAccessories: LeadingAccessories?

    let trailingAccessories: TrailingAccessories?

    @State private var caseSensitive: Bool = false

    var clearable: Bool

    var onClear: () -> Void

    var hasValue: Bool

    init(
        _ label: String,
        text: Binding<String>,
        axis: Axis? = .horizontal,
        @ViewBuilder leadingAccessories: () -> LeadingAccessories? = { EmptyView() },
        @ViewBuilder trailingAccessories: () -> TrailingAccessories? = { EmptyView() },
        clearable: Bool? = true,
        onClear: (() -> Void)? = {},
        hasValue: Bool? = false
    ) {
        self.label = label
        _text = text
        self.axis = axis ?? .horizontal
        self.leadingAccessories = leadingAccessories()
        self.trailingAccessories = trailingAccessories()
        self.clearable = clearable ?? true
        self.onClear = onClear ?? {}
        self.hasValue = hasValue ?? false
    }

    @ViewBuilder
    public func selectionBackground(
        _ isFocused: Bool = false
    ) -> some View {
        if controlActive != .inactive || !text.isEmpty || hasValue {
            if isFocused || !text.isEmpty || hasValue {
                Color(.textBackgroundColor)
            } else {
                if colorScheme == .light {
                    Color.black.opacity(0.06)
                } else {
                    Color.white.opacity(0.24)
                }
            }
        } else {
            if colorScheme == .light {
                Color.clear
            } else {
                Color.white.opacity(0.14)
            }
        }
    }

    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            if leadingAccessories != nil {
                Image(systemName: "magnifyingglass")
                    .padding(.leading, 16)
                    .foregroundStyle(.tertiary)
                    .font(.system(size: 13).weight(.light))
                    .frame(width: 16, height: 32)
            }
            VStack {
                TextField(label, text: $text, axis: axis)
                    .textFieldStyle(.plain)
                    .focused($isFocused)
                    .controlSize(.large)
                    .font(.system(size: 13).weight(.light))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .foregroundStyle(.primary)
            }
            if clearable == true {
                Button {
                    self.text = String.Empty
                    onClear()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                }
                .buttonStyle(.borderless)
                .opacity(text.isEmpty ? 0 : 1)
                .disabled(text.isEmpty)
                .padding(.trailing, 7)
                .padding(.top, 9)
            }
            Divider().padding(.trailing, 16)
            if trailingAccessories != nil {
                Image(systemName: "textformat")
                    .foregroundStyle(Color(.secondaryLabelColor))
                    .padding(.trailing, 16)
                    .foregroundStyle(.tertiary)
                    .font(.system(size: 13).weight(.light))
                    .frame(width: 16, height: 32)
            }
        }
        .fixedSize(horizontal: false, vertical: true)
        .frame(minHeight: 32)
        .background(
            selectionBackground(isFocused)
                .clipShape(RoundedRectangle(cornerRadius: 6))
                .edgesIgnoringSafeArea(.all)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke(isFocused || !text.isEmpty || hasValue ? .tertiary : .quaternary, lineWidth: 1.25)
                .clipShape(RoundedRectangle(cornerRadius: 6))
                .disabled(true)
                .edgesIgnoringSafeArea(.all)
        )

        .onTapGesture {
            isFocused = true
        }
        .padding(.horizontal, 8)
    }
}
