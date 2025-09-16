//
//  Extension+View.swift
//  MathSymbolPicker
//
//  Created by christian on 31/07/24.
//

import SwiftUI

/// The injectReader modifier function
///
/// When you implement a custom modifier, you must implement a computed
/// `body` property to provide the content for your view. Return a view
/// that's composed of built-in views that SwiftUI provides, plus other
/// composite views that you've already defined:
///
///     GeometryReader { geometry in
///        ScrollView(.horizontal, showsIndicators: true) {
///           content
///             .frame(width: geometry.size.width)
///             .frame(minHeight: geometry.size.height)
///      }
///  }
///
/// For more information about composing views and a view hierarchy,
/// see <doc:Declaring-a-Custom-View>.
extension View {
    func injectReader(_ width: @escaping (CGFloat?) -> Void) -> some View {
        modifier(AddReaderModifier(width: width))
    }
}

/// The content and behavior of the VScrollView.
///
/// When you implement a custom view, you must implement a computed
/// `body` property to provide the content for your view. Return a view
/// that's composed of built-in views that SwiftUI provides, plus other
/// composite views that you've already defined:
///
///     GeometryReader { geometry in
///        ScrollView(.horizontal, showsIndicators: true) {
///           content
///             .frame(width: geometry.size.width)
///             .frame(minHeight: geometry.size.height)
///      }
///  }
///
/// For more information about composing views and a view hierarchy,
/// see <doc:Declaring-a-Custom-View>.
fileprivate struct AddReaderModifier: ViewModifier {
    private struct AddReaderPreferenceKey: PreferenceKey {
        static func reduce(value: inout CGFloat?, nextValue: () -> CGFloat?) {
            value = nextValue()
        }
    }

    let width: (CGFloat?) -> Void

    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { geometryReader in
                    Color.clear
                        .preference(key: AddReaderPreferenceKey.self, value: geometryReader.size.width)
                        .onAppear {
                            width(geometryReader.size.width)
                        }
                }
            )
            .onPreferenceChange(AddReaderPreferenceKey.self) { width in
                self.width(width)
            }
    }
}
