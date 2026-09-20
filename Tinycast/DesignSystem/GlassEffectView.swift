import SwiftUI

public enum LiquidGlassVariant: Int, @unchecked Sendable, CaseIterable {
    case regular = 0
    case clear = 1
    // Note: Other styles exist but are private APIs
    // This enum allows for future expansion
}

/// Native Liquid Glass backdrop, ignoring fallback as the app is only supported on macOS 26+
struct GlassEffectView: NSViewRepresentable {
    var style: LiquidGlassVariant = .regular
    var cornerRadius: CGFloat = 0

    func makeNSView(context: Context) -> NSGlassEffectView {
        let view = NSGlassEffectView()
        view.style = NSGlassEffectView.Style(style)
        view.cornerRadius = cornerRadius
        return view
    }

    func updateNSView(_ nsView: NSGlassEffectView, context: Context) {
        nsView.style = NSGlassEffectView.Style(style)
        nsView.cornerRadius = cornerRadius
    }
}

extension NSGlassEffectView.Style {
    init(_ variant: LiquidGlassVariant) {
        self = unsafeBitCast(variant.rawValue, to: Self.self)
    }
}
