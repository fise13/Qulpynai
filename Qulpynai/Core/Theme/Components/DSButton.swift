//
//  DSButton.swift
//  Qulpynai
//
//  Design system button styles
//

import SwiftUI

enum DSButtonStyle {
    case primary
    case secondary
    case tertiary
    case disabled
}

struct DSButton: View {
    let title: LocalizedStringKey
    let style: DSButtonStyle
    let action: () -> Void
    var isFullWidth: Bool = true

    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(DSTypography.title)
                .frame(maxWidth: isFullWidth ? .infinity : nil)
                .frame(height: style == .primary ? 48 : 44)
                .foregroundStyle(foregroundColor)
                .background(backgroundColor)
                .overlay(borderOverlay)
                .clipShape(RoundedRectangle(cornerRadius: DSCornerRadius.medium))
        }
        .buttonStyle(ScaleButtonStyle())
        .disabled(style == .disabled)
    }

    private var foregroundColor: Color {
        switch style {
        case .primary:
            return DSColors.surface
        case .secondary, .tertiary:
            return DSColors.primary(theme: colorScheme)
        case .disabled:
            return DSColors.textTertiary(theme: colorScheme)
        }
    }

    private var backgroundColor: Color {
        switch style {
        case .primary:
            return DSColors.primary(theme: colorScheme)
        case .secondary, .disabled:
            return DSColors.surfaceVariant(theme: colorScheme)
        case .tertiary:
            return .clear
        }
    }

    @ViewBuilder
    private var borderOverlay: some View {
        if style == .secondary {
            RoundedRectangle(cornerRadius: DSCornerRadius.medium)
                .stroke(DSColors.primary(theme: colorScheme), lineWidth: 1)
        }
    }
}

#Preview {
    VStack(spacing: DSSpacing.md) {
        DSButton(title: "Add to Cart", style: .primary) {}
        DSButton(title: "Continue as Guest", style: .secondary) {}
        DSButton(title: "Skip", style: .tertiary) {}
        DSButton(title: "Disabled", style: .disabled) {}
    }
    .padding()
}
