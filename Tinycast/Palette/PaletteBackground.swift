import SwiftUI

struct PaletteBackground: View {
    @Environment(AppSettings.self) private var settings
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.displayScale) private var displayScale
    @Environment(\.metrics) private var metrics
    let window: NSWindow?
    var collapsed: Bool = false

    private var usesSystemShadow: Bool {
        colorScheme != .dark || settings.paletteTransparency <= 0
    }

    @ViewBuilder
    var body: some View {
            //        Theme.Colors.panelScrim(transparency: settings.paletteTransparency)
        if (collapsed) {
            ZStack {
                LinearGradient(
                    stops: [
                        Gradient.Stop(color: Theme.Colors.adaptive(dark: .black.withAlphaComponent(1), light: .white.withAlphaComponent(0.5)), location: 0),
                        Gradient.Stop(color: Theme.Colors.adaptive(dark: .black.withAlphaComponent(0.9), light: .white.withAlphaComponent(0.4)), location: 0.2),
                        Gradient.Stop(color: Theme.Colors.adaptive(dark: .black.withAlphaComponent(0.75), light: .white.withAlphaComponent(0.3)), location: 0.4),
                        Gradient.Stop(color: Theme.Colors.adaptive(dark: .black.withAlphaComponent(0.55), light: .white.withAlphaComponent(0.2)), location: 0.6),
                        Gradient.Stop(color: Theme.Colors.adaptive(dark: .black.withAlphaComponent(0.3), light: .white.withAlphaComponent(0.1)), location: 0.8),
                        Gradient.Stop(color: .clear, location: 1),
                    ],
                    startPoint: .top,
                    endPoint: .bottom)
                GlassEffectView()
            }
        } else {
            LinearGradient(
                stops: [
                    Gradient.Stop(color: Theme.Colors.adaptive(dark: .black.withAlphaComponent(1),  light: .white.withAlphaComponent(0.7)), location: 0),
                    Gradient.Stop(color: Theme.Colors.adaptive(dark: .black.withAlphaComponent(0.9),  light:.white.withAlphaComponent(0.55)), location: 0.2),
                    Gradient.Stop(color: Theme.Colors.adaptive(dark: .black.withAlphaComponent(0.75),  light: .white.withAlphaComponent(0.45)), location: 0.4),
                    Gradient.Stop(color: Theme.Colors.adaptive(dark: .black.withAlphaComponent(0.6),  light:.white.withAlphaComponent(0.4)), location: 0.6),
                    Gradient.Stop(color: Theme.Colors.adaptive(dark: .black.withAlphaComponent(0.45),  light: .white.withAlphaComponent(0.35)), location: 0.8),
                    Gradient.Stop(color: Theme.Colors.adaptive(dark: .black.withAlphaComponent(0.3),  light:.white.withAlphaComponent(0.3)), location: 1),
                ],
                startPoint: .top,
                endPoint: .bottom)
            GlassEffectView()
        }
            //    private func applyShadow() {
            //        guard let window, window.hasShadow != usesSystemShadow else { return }
            //        window.hasShadow = usesSystemShadow
            //        window.invalidateShadow()
            //    }
    }
}
