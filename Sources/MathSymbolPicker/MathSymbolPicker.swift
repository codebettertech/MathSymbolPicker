//
//  MathSymbolPicker.swift
//  MathSymbolPicker
//
//  Created by CodeBetter Inc. on 25/07/24.
//

import SwiftUI

protocol MathSymbolPickerDelegate: NSObject {
    init(symbol: Binding<String>)

    init(symbol: Binding<String?>)

    @ViewBuilder var searchableSymbolGrid: any View { get }

    var symbolGrid: any View { get }

    var deleteButton: any View { get }

    var canDeleteIcon: Bool { get set }

    var symbols: [String] { get set }

    func mathSymbolPicker(_ picker: MathSymbolPicker, didSelect symbol: String)

    var size: CGFloat { get set }

    var symbolWeight: Font.Weight { get set }

    var gridDimension: CGFloat { get set }

    var symbolSize: CGFloat { get set }

    var symbolCornerRadius: CGFloat { get set }

    var unselectedItemBackgroundColor: Color { get set }

    var selectedItemBackgroundColor: Color { get set }

    var backgroundColor: Color { get set }

    var foregroundColor: Color { get set }

    var deleteButtonTextPadding: CGFloat { get set }

    var deleteButtonTextVerticalPadding: CGFloat { get set }
}

/// A simple and cross-platform SFSymbol picker for SwiftUI.
public struct MathSymbolPicker: View {
    // MARK: - Static constants

    private let grid: [GridItem] = [
        GridItem(.adaptive(minimum: Self.gridDimension, maximum: Self.gridDimension)),
    ]

    private enum Dimension {
        case extraSmall
        case small
        case medium
        case regular
        case large
        case extraLarge
        case xxl
        case custom(v: CGFloat)

        var size: CGFloat {
            switch self {
            case .extraSmall:
                return 8
            case .small:
                return 12
            case .medium:
                return 24
            case .regular:
                return 48
            case .large:
                return 64
            case .extraLarge:
                return 96
            case .xxl:
                return 128
            case let .custom(v):
                return v
            }
        }
    }

    private static var gridDimension: CGFloat {
        #if os(iOS)
            return Dimension.large.size
        #elseif os(tvOS)
            return Dimension.xxl.size
        #elseif os(macOS)
            return Dimension.extraLarge.size
        #else
            return Dimension.regular.size
        #endif
    }

    private static var symbolSize: CGFloat {
        #if os(iOS)
            return Dimension.medium.size
        #elseif os(tvOS)
            return Dimension.regular.size
        #elseif os(macOS)
            return Dimension.medium.size
        #else
            return Dimension.medium.size
        #endif
    }

    static var symbolWeight: Font.Weight {
        #if os(iOS)
            return Font.Weight.medium
        #elseif os(tvOS)
            return Font.Weight.regular
        #elseif os(macOS)
            return Font.Weight.medium
        #else
            return Font.Weight.medium
        #endif
    }

    private static var symbolCornerRadius: CGFloat {
        #if os(iOS)
            return Dimension.extraSmall.size
        #elseif os(tvOS)
            return Dimension.small.size
        #elseif os(macOS)
            return Dimension.extraSmall.size
        #else
            return Dimension.extraSmall.size
        #endif
    }

    private static var unselectedItemBackgroundColor: Color {
        #if os(iOS)
            return Color(UIColor.systemBackground)
        #else
            return Color.accentColor
        #endif
    }

    private static var selectedItemBackgroundColor: Color {
        #if os(tvOS)
            return Color.gray.opacity(0.3)
        #else
            return Color.accentColor
        #endif
    }

    private static var backgroundColor: Color {
        #if os(iOS)
            return Color(UIColor.secondarySystemBackground)
        #else
            return .clear
        #endif
    }

    public var foregroundColor: Color {
        #if os(iOS)
            return Color(UIColor.primaarySystemBackground)
        #else
            return .white
        #endif
    }

    private static var deleteButtonTextVerticalPadding: CGFloat {
        #if os(iOS)
            return 12.0
        #else
            return 8.0
        #endif
    }

    // MARK: - Properties

    @Binding public var symbol: String?
    @State private var searchText = ""
    @Environment(\.dismiss) private var dismiss

    private let nullable: Bool

    // MARK: - Init

    /// Initializes `MathSymbolPicker` with a string binding to the selected symbol name.
    ///
    /// - Parameters:
    ///   - symbol: A binding to a `String` that represents the name of the selected symbol.
    ///     When a symbol is picked, this binding is updated with the symbol's name.
    public init(symbol: Binding<String>) {
        self.init(
            symbol: Binding {
                symbol.wrappedValue
            } set: { newValue in
                /// As the `nullable` is set to `false`, this can not be `nil`
                if let newValue {
                    symbol.wrappedValue = newValue
                }
            },
            nullable: false)
    }

    /// Initializes `MathSymbolPicker` with a nullable string binding to the selected symbol name.
    ///
    /// - Parameters:
    ///   - symbol: A binding to a `String` that represents the name of the selected symbol.
    ///     When a symbol is picked, this binding is updated with the symbol's name. When no symbol
    ///     is picked, the value will be `nil`.
    public init(symbol: Binding<String?>) {
        self.init(symbol: symbol, nullable: true)
    }

    
        /// Description
        /// - Parameters:
        ///   - symbol: A binding to a `String` that represents the name of the selected symbol.
        ///     When a symbol is picked, this binding is updated with the symbol's name. When no symbol
        ///     is picked, the value will be `nil`.
        ///   - nullable: boolean value to determinate the remove button visibility
    private init(symbol: Binding<String?>,
                 nullable: Bool) {
        _symbol = symbol
        self.nullable = nullable
    }

    // MARK: - View Components

    @ViewBuilder
    private var searchableSymbolGrid: some View {
        #if os(iOS)
            symbolGrid
                .searchable(
                    text: $searchText,
                    placement: .navigationBarDrawer(displayMode: .always))
        #elseif os(tvOS)
            VStack {
                TextField(
                    MathSymbolFunction.localizedString(key: "search_placeholder"), text: $searchText)
                    .padding(.horizontal, 8)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                symbolGrid
            }

        /// `searchable` is crashing on tvOS 16. What the hell aPPLE?
        ///
        /// symbolGrid
        ///     .searchable(text: $searchText, placement: .automatic)
        #elseif os(macOS)
            VStack(spacing: 0) {
                HStack {
                    TextField(MathSymbolFunction.localizedString(key: "search_placeholder"), text: $searchText)
                        .textFieldStyle(.plain)
                        .font(.system(size: 18.0))
                        .disableAutocorrection(true)

                    Button {
                        // dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .frame(width: 16.0, height: 16.0)
                    }
                    .buttonStyle(.borderless)
                }.padding()
                Divider()
                symbolGrid

                if canDeleteIcon {
                    Divider()
                    HStack {
                        Spacer()
                        deleteButton
                            .padding(.horizontal)
                            .padding(.vertical, 8.0)
                    }
                }
            }
        #else
            symbolGrid.searchable(text: $searchText, placement: .automatic)
        #endif
    }

    private var symbolGrid: some View {
        ScrollView {
            #if os(tvOS) || os(watchOS)
                if canDeleteIcon {
                    deleteButton
                }
            #endif

            LazyVGrid(columns: [GridItem(.adaptive(minimum: Self.gridDimension, maximum: Self.gridDimension))]
            ) {
                ForEach(symbols.filter { searchText.isEmpty ? true : $0.localizedCaseInsensitiveContains(searchText) }, id: \.self) {
                    thisSymbol in
                    Button {
                        symbol = thisSymbol
                        // dismiss()
                    } label: {
                        if thisSymbol == symbol {
                            Image(systemName: thisSymbol)
                                .font(
                                    .system(size: Dimension.regular.size)
                                        .weight(.thin)
                                )
                                .foregroundColor(
                                    foregroundColor
                                )
                            #if os(tvOS)
                                .frame(minWidth: Self.gridDimension, minHeight: Self.gridDimension)
                            #else
                                .frame(maxWidth: .infinity, minHeight: Self.gridDimension)
                            #endif
                                .background(Self.selectedItemBackgroundColor)
                            #if os(visionOS)
                                .clipShape(Circle())
                            #else
                                .cornerRadius(Self.symbolCornerRadius)
                            #endif
                                .foregroundColor(.white)
                        } else {
                            Image(systemName: thisSymbol)
                                .font(.system(size: Dimension.regular.size).weight(.thin))
                                .foregroundColor(
                                    foregroundColor
                                )
                                .frame(maxWidth: .infinity, minHeight: Self.gridDimension)
                                .background(Self.unselectedItemBackgroundColor)
                                .cornerRadius(Self.symbolCornerRadius)
                                .foregroundColor(.primary)
                        }
                    }
                    .buttonStyle(.plain)
                    #if os(iOS)
                        .hoverEffect(.lift)
                    #endif
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 10)

            #if os(iOS) || os(visionOS)
                /// Avoid last row being hidden.
                if canDeleteIcon {
                    Spacer()
                        .frame(height: Self.gridDimension * 2)
                }
            #endif
        }
    }

    private var deleteButton: some View {
        Button(role: .destructive) {
            symbol = nil
            // dismiss()
        } label: {
            Label(MathSymbolFunction.localizedString(key: "remove_symbol"), systemImage: "trash")
            #if !os(tvOS) && !os(macOS)
                .frame(maxWidth: .infinity)
            #endif
            #if !os(watchOS)
            .padding(.vertical, Self.deleteButtonTextVerticalPadding)
            #endif
            .background(.clear)
            .clipShape(RoundedRectangle(cornerRadius: 12.0, style: .continuous))
        }
    }

    public var body: some View {
        #if !os(macOS)
            NavigationView {
                ZStack {
                    #if os(iOS)
                        Self.backgroundColor.edgesIgnoringSafeArea(.all)
                    #endif
                    searchableSymbolGrid

                    #if os(iOS) || os(visionOS)
                        if canDeleteIcon {
                            VStack {
                                Spacer()

                                deleteButton
                                    .padding()
                                    .background(.regularMaterial)
                            }
                        }
                    #endif
                }
                #if os(iOS)
                .navigationBarTitleDisplayMode(.inline)
                #endif
                #if !os(tvOS)
                /// tvOS can use back button on remote
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button {
                            dismiss()
                        } label: {
                            Text(localizedString("cancel"))
                        }
                    }
                }
                #endif
            }
            .navigationViewStyle(.stack)
        #else
            searchableSymbolGrid
                .frame(width: 460, height: 640, alignment: .center)
                .background(.regularMaterial)
        #endif
    }

    private var canDeleteIcon: Bool {
        nullable && symbol != nil
    }

    private var symbols: [String] {
        MathSymbol.shared.symbols
    }
}

// MARK: - Debug

#if DEBUG
    #Preview("Normal") {
        struct Preview: View {
            @State private var symbol: String? = "square.and.circle.fill"
            var body: some View {
                MathSymbolPicker(symbol: $symbol)
            }
        }
        return Preview()
    }
#endif
