//
//  DSCard.swift
//  Qulpynai
//
//  Design system card component
//

import SwiftUI

struct DSCard<Content: View>: View {
    let content: Content
    var elevated: Bool = false

    @Environment(\.colorScheme) private var colorScheme

    init(elevated: Bool = false, @ViewBuilder content: () -> Content) {
        self.elevated = elevated
        self.content = content()
    }

    var body: some View {
        content
            .padding(DSSpacing.md)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(DSColors.surface(theme: colorScheme))
            .clipShape(RoundedRectangle(cornerRadius: DSCornerRadius.medium))
            .shadow(
                color: .black.opacity(elevated ? 0.08 : 0.04),
                radius: elevated ? 12 : 4,
                x: 0,
                y: elevated ? 4 : 2
            )
    }
}
