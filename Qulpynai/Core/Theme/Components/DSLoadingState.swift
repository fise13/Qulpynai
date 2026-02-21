//
//  DSLoadingState.swift
//  Qulpynai
//
//  Design system loading state
//

import SwiftUI

struct DSLoadingState: View {
    var message: LocalizedStringKey = "Loading..."

    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(spacing: DSSpacing.md) {
            ProgressView()
                .scaleEffect(1.2)
                .tint(DSColors.primary(theme: colorScheme))
            Text(message)
                .font(DSTypography.bodySmall)
                .foregroundStyle(DSColors.textSecondary(theme: colorScheme))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct DSSkeletonView: View {
    var width: CGFloat = 120
    var height: CGFloat = 16

    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        RoundedRectangle(cornerRadius: 4)
            .fill(DSColors.surfaceVariant(theme: colorScheme))
            .frame(width: width, height: height)
    }
}
