//
//  DSEmptyState.swift
//  Qulpynai
//
//  Design system empty state
//

import SwiftUI

struct DSEmptyState: View {
    let icon: String
    let title: LocalizedStringKey
    let subtitle: LocalizedStringKey?
    var actionTitle: LocalizedStringKey? = nil
    var action: (() -> Void)? = nil

    @Environment(\.colorScheme) private var colorScheme

    init(
        icon: String = "tray",
        title: LocalizedStringKey,
        subtitle: LocalizedStringKey? = nil,
        actionTitle: LocalizedStringKey? = nil,
        action: (() -> Void)? = nil
    ) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.actionTitle = actionTitle
        self.action = action
    }

    var body: some View {
        VStack(spacing: DSSpacing.lg) {
            Image(systemName: icon)
                .font(.system(size: 48))
                .foregroundStyle(DSColors.textTertiary(theme: colorScheme))

            VStack(spacing: DSSpacing.sm) {
                Text(title)
                    .font(DSTypography.subheadline)
                    .foregroundStyle(DSColors.textPrimary(theme: colorScheme))
                    .multilineTextAlignment(.center)

                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(DSTypography.bodySmall)
                        .foregroundStyle(DSColors.textSecondary(theme: colorScheme))
                        .multilineTextAlignment(.center)
                }
            }

            if let actionTitle = actionTitle, let action = action {
                DSButton(title: actionTitle, style: .secondary, action: action, isFullWidth: false)
            }
        }
        .padding(DSSpacing.xl)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
