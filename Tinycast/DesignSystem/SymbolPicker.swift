import SwiftUI

/// A grid of SF Symbols with an Automatic escape hatch; the symbols are the caller's.
struct SymbolPicker: View {
    @Binding var selection: String?
    /// Drawn on the Automatic row, and what the row falls back to when nothing is picked.
    let fallback: String

    @State var editingCustom: String = ""
    @State private var validImage = false
    @FocusState private var focusedField: Bool

    let symbols: [String]
    let onPick: () -> Void

    private static let cell: CGFloat = 30
    private static let cellHeight: CGFloat = 26
    private static let columnCount = 6

    private var columns: [GridItem] {
        Array(repeating: GridItem(.fixed(Self.cell), spacing: Theme.Spacing.sm), count: Self.columnCount)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.md) {
            Button {
                selection = nil
                onPick()
            } label: {
                HStack(spacing: Theme.Spacing.sm) {
                    SymbolImage(name: fallback, size: 14)
                    Text("Automatic")
                    Spacer(minLength: 0)
                }
                .contentShape(Rectangle())
                .padding(.leading, Theme.Spacing.sm)
            }
            .buttonStyle(.plain)
            Divider()
            LazyVGrid(columns: columns, spacing: Theme.Spacing.sm) {
                ForEach(symbols, id: \.self) { symbol in
                    Button {
                        selection = symbol
                        onPick()
                    } label: {
                        SymbolImage(name: symbol, size: 15)
                            .frame(width: Self.cell, height: Self.cellHeight)
                            .background(
                                RoundedRectangle(cornerRadius: Theme.Radius.menu, style: .continuous)
                                    .fill(selection == symbol ? Theme.Colors.selection : Color.clear)
                            )
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                }
            }
            Divider()
            HStack {
                Text("Custom")
                TextField("SF Symbol", text: $editingCustom)
                    .textFieldStyle(.roundedBorder)
                    .focused($focusedField)
                if validImage {
                    SymbolImage(name: $editingCustom.wrappedValue, size: 14)
                } else {
                    SymbolImage(name: "xmark.circle", size: 14)
                        .foregroundStyle(Theme.Colors.destructive)
                }
            }.onChange(of: $editingCustom.wrappedValue, initial: true) {
                if NSImage(systemSymbolName: $editingCustom.wrappedValue, accessibilityDescription: "ValidImageCheck") != nil {
                    validImage = true
                } else {
                    validImage = false
                }
            }.onSubmit {
                if validImage {
                    selection = $editingCustom.wrappedValue
                    onPick()
                }
            }
        }
        .padding(Theme.Spacing.md)
        .frame(width: Self.width)
        .onAppear {
            focusedField = true
        }
    }

    private static let width: CGFloat = 244
}


#Preview {
    @Previewable @State var iconSymbol: String?
    @Previewable @State var showingIconPicker: Bool = false

    let iconSymbols = [
        "terminal", "hammer", "wrench", "gearshape", "bolt", "arrow.clockwise", "trash",
        "shippingbox", "cube", "server.rack", "externaldrive", "internaldrive", "cloud",
        "arrow.up.circle", "arrow.down.circle", "doc.text", "folder", "magnifyingglass",
        "ladybug", "chevron.left.forwardslash.chevron.right", "network", "lock", "key",
        "display", "speaker.wave.2", "moon", "sun.max", "power", "clock", "calendar",
        "chart.bar", "flame"
    ]

    Button {
        showingIconPicker = true
    } label: {
        HStack(spacing: Theme.Spacing.sm) {
            SymbolImage(name: iconSymbol ?? "terminal", size: 14)
            Text(iconSymbol == nil ? "Automatic" : "Custom")
                .lineLimit(1)
            Spacer(minLength: 0)
        }
    }
    .popover(isPresented: $showingIconPicker, arrowEdge: .bottom) {
        SymbolPicker(
            selection: $iconSymbol, fallback: "terminal", editingCustom: iconSymbol ?? "terminal",
            symbols: iconSymbols
        ) {
            showingIconPicker = false
        }
    }
}
