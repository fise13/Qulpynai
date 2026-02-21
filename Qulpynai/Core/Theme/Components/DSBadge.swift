//
//  DSBadge.swift
//  Qulpynai
//
//  Design system badge — count overlay
//

import SwiftUI

struct DSBadge: View {
    let count: Int

    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        if count > 0 {
            Text(count > 99 ? "99+" : "\(count)")
                .font(DSTypography.captionSmall)
                .foregroundStyle(DSColors.surface)
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .background(DSColors.error(theme: colorScheme))
                .clipShape(Capsule())
        }
    }
}
