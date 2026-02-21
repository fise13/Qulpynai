//
//  DSChip.swift
//  Qulpynai
//
//  Design system chip — category, filter
//

import SwiftUI

struct DSChip: View {
    let title: String
    var isSelected: Bool = false
    let action: () -> Void

    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(DSTypography.bodySmall)
                .padding(.horizontal, DSSpacing.md)
                .padding(.vertical, DSSpacing.sm)
                .foregroundStyle(isSelected ? DSColors.surface : DSColors.textPrimary(theme: colorScheme))
                .background(isSelected ? DSColors.primary(theme: colorScheme) : DSColors.surfaceVariant(theme: colorScheme))
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}
