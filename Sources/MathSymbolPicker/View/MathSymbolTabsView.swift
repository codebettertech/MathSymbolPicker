///
///  MathSymbolTabsView.swift
///  MathSymbolPicker
///
/// Created by christian on 27/07/24.
///

import SwiftUI

public extension Color {
    #if os(macOS)
        static let backgroundColor = Color(NSColor.windowBackgroundColor)
        static let secondaryBackgroundColor = Color(NSColor.controlBackgroundColor)
    #else
        static let backgroundColor = Color(UIColor.systemBackground)
        static let secondaryBackgroundColor = Color(UIColor.secondarySystemBackground)
    #endif
}

public struct CustomTabView: View {
    public enum TabBarPosition { // Where the tab bar will be located within the view
        case top
        case bottom
    }

    private let tabBarPosition: TabBarPosition
    private let tabText: [String]
    private let tabIconNames: [String]
    private let tabViews: [AnyView]

    @State private var selection = 0

    public init(tabBarPosition: TabBarPosition, content: [(tabText: String, tabIconName: String, view: AnyView)]) {
        self.tabBarPosition = tabBarPosition
        tabText = content.map { $0.tabText }
        tabIconNames = content.map { $0.tabIconName }
        tabViews = content.map { $0.view }
    }

    public var tabBar: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 10) {
                ForEach(0 ..< tabText.count, id: \.self) { index in
                    Button {
                        self.selection = index
                    } label: {
                        Image(systemName: self.tabIconNames[index]).padding(6)
                        Text(self.tabText[index])
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .padding(4)
            .shadow(color: Color.clear, radius: 0, x: 0, y: 0)
            .shadow(
                color: Color.black.opacity(0.25),
                radius: 3,
                x: 0,
                y: tabBarPosition == .top ? 1 : -1
            )
            .zIndex(99)
        }.frame(width: .infinity, alignment: .center)
    } // Raised so that shadow is visible above view backgrounds

    public var body: some View {
        VStack(spacing: 0) {
            if self.tabBarPosition == .top {
                tabBar
            }

            tabViews[selection]
                .padding(0)
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            if self.tabBarPosition == .bottom {
                tabBar
            }
        }
    }
}

struct CustomTabsView: View {
    var body: some View {
        CustomTabView(
            tabBarPosition: .top,
            content: [
                (
                    tabText: "Tab 1",
                    tabIconName: "gear",
                    view: AnyView(
                        HStack {
                            Spacer()
                            VStack {
                                Spacer()
                                Text("First Tab!")
                                Spacer()
                            }
                            Spacer()
                        }
                        .background(Color.blue)
                    )
                ),
                (
                    tabText: "Tab 2",
                    tabIconName: "gear",
                    view: AnyView(
                        HStack {
                            Spacer()
                            VStack {
                                Spacer()
                                Text("Second Tab!")
                                Spacer()
                            }
                            Spacer()
                        }
                        .background(Color.red)
                    )
                ),
                (
                    tabText: "Tab 3",
                    tabIconName: "gear",
                    view: AnyView(
                        HStack {
                            Spacer()
                            VStack {
                                Spacer()
                                Text("Third Tab!")
                                Spacer()
                            }
                            Spacer()
                        }
                        .background(Color.yellow)
                    )
                )
            ]
        )
    }
}

struct MathSymbolTabsView: View {
    @Binding var selectedTab: Int
    private let tabLabelCollection: [String] = ["Analysis", "Algebra", "Geometry", "Trigonometry", "Analysi", "Algebr", "Geometr", "Trignometry"]
    private let iconNameCollection: [String] = ["function", "sum", "Geometry", "angle", "function", "sum", "Geometry", "angle"]

    let items = 1 ... 4

    let rows = [
        GridItem(.flexible(minimum: 50, maximum: 150)),
    ]

    let item = GridItem(.flexible(minimum: 50, maximum: 150))

    private struct Buttons: View {
        var body: some View {
            Text("w")
        }
//                LazyHStack {
//                    ForEach(0 ..< 4) { index in
//                        HStack {
//                            Button {
//                            } label: {
//                                Image(systemName: "gear")
//                                Text("Tab \(index)")
//                            }
//                            .buttonStyle(.bordered)
//                        }.frame(
//                            width: .infinity,
//                            alignment: .init(
//                                horizontal: .center,
//                                vertical: .center
//                            )
//                        )
//                    }
//                }.clipped()
//        }
    }

    var body: some View {
        ScrollView(.horizontal) {
            LazyHGrid(rows: rows) {
                ForEach(0 ..< 4) { index in
                    GridRow {
                        Button {
                        } label: {
                            Image(systemName: "gear")
                            Text("Tab \(index)")
                        }
                        .buttonStyle(.bordered)
                    }
                }
            }
        }
    }
}

#if DEBUG
    #Preview("MathSymbolTabsView") {
        struct Preview: View {
            var body: some View {
                CustomTabsView()
            }
        }
        return Preview()
    }
#endif
