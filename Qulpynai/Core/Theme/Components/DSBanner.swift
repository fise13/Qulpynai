//
//  DSBanner.swift
//  Qulpynai
//
//  Design system banner — promo, alert
//

import SwiftUI

struct DSBanner: View {
    let title: String
    var subtitle: String? = nil
    var icon: String = "tag.fill"
    var style: Style = .promo
    var action: (() -> Void)? = nil

    enum Style {
        case promo
        case alert
    }

    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        Button(action: { action?() }) {
            HStack(spacing: DSSpacing.md) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(foregroundColor)

                VStack(alignment: .leading, spacing: DSSpacing.xs) {
                    Text(title)
                        .font(DSTypography.title)
                        .foregroundStyle(foregroundColor)
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(DSTypography.caption)
                            .foregroundStyle(foregroundColor.opacity(0.9))
                    }
                }
                Spacer()
                if action != nil {
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundStyle(foregroundColor.opacity(0.8))
                }
            }
            .padding(DSSpacing.md)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: DSCornerRadius.medium))
        }
        .buttonStyle(ScaleButtonStyle())
        .disabled(action == nil)
    }

    private var foregroundColor: Color {
        style == .promo ? DSColors.surface : DSColors.textPrimary(theme: colorScheme)
    }

    @ViewBuilder
    private var backgroundColor: some View {
        if style == .promo {
            LinearGradient(
                colors: [
                    DSColors.secondary(theme: colorScheme),
                    DSColors.secondary(theme: colorScheme).opacity(0.85)
                ],
                startPoint: .leading,
                endPoint: .trailing
            )
        } else {
            DSColors.surfaceVariant(theme: colorScheme)
        }
    }
}
