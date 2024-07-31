//
//  Untitled.swift
//  MathSymbolPicker
//
//  Created by christian on 31/07/24.
//

import SwiftUI

enum HorizontalScrollViewContainerProperty: Identifiable, CaseIterable {
    case showsIndicators

    var id: HorizontalScrollViewContainerProperty { self }

    // let's suppose each playground has a title property, as an example
    var indicator: Bool {
        switch self {
        case .showsIndicators: return true
        }
    }

    // if you have more common properties,
    // perhaps bundle them all into a struct
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
struct HorizontalScrollViewContainer<Content>: View where Content: View {
    @ViewBuilder private(set) var content: Content
    private(set) var height: CGFloat
    private(set) var backgroundColor: Color?

    var body: some View {
        ScrollView(.horizontal, showsIndicators: true) {
            content
        }
        .frame(width: .infinity, height: height)
        .background(backgroundColor!)
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
///            HStack {
///               Button {
///               } label: {
///                 Image(systemName: "applelogo")
///                   .font(.largeTitle)
///                   .padding(4)
///               }
///               Button {
///               } label: {
///                 Image(systemName: "applelogo")
///                   .font(.largeTitle)
///                   .padding(4)
///               }
///             }
///             ....
///         }
///    }
///
/// For more information about composing views and a view hierarchy,
/// see <doc:Declaring-a-Custom-View>.
///
///

/// The content and behavior of the VScrollView.
///
/// When you implement a custom view, you must implement a computed
/// `body` property to provide the content for your view. Return a view
/// that's composed of built-in views that SwiftUI provides, plus other
/// composite views that you've already defined:
///
///        GeometryReader { geometry in
///               Button {
///               } label: {
///                   Image(systemName: "applelogo")
///                      .font(.largeTitle)
///                      .padding(4)
///        }
///  }
///
/// For more information about composing views and a view hierarchy,
/// see <doc:Declaring-a-Custom-View>.
struct HorizontalScrollViewItem<Content>: View where Content: View {
    fileprivate enum ScroolItemType {
        case label
        case button
        case text
        case image
        case textField
        case editorText
    }

    var body: some View {
        GeometryReader { _ in
            Button {
            } label: {
                Image(systemName: "applelogo")
                    .font(.largeTitle)
                    .padding(4)
            }
        }
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
///            HStack {
///               Button {
///               } label: {
///                 Image(systemName: "applelogo")
///                   .font(.largeTitle)
///                   .padding(4)
///               }
///               Button {
///               } label: {
///                 Image(systemName: "applelogo")
///                   .font(.largeTitle)
///                   .padding(4)
///               }
///             }
///             ....
///         }
///    }
///
/// For more information about composing views and a view hierarchy,
/// see <doc:Declaring-a-Custom-View>.
///
///

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
struct HorizontalScrollView: View {
    var body: some View {
        let rows = [GridItem(.fixed(30))]

        ScrollView(.horizontal, showsIndicators: true) {
            LazyHGrid(rows: rows) {
                ForEach(0 ... 30, id: \.self) { v in
                    HStack {
                        Button {
                            print(v)
                        } label: {
                            Image(systemName: "applelogo")
                                .font(.title2)
                                .padding(4)
                            Text("Tutti")
                        }
                        .buttonStyle(.bordered)
                        .padding(4)
                    }
                }
            }
            .padding()
        }
    }
}

#if DEBUG
    #Preview("HorizontalScrollView") {
        struct Preview: View {
            var body: some View {
                HorizontalScrollView()
            }
        }
        return Preview()
    }
#endif
