//
//  DSProductCard.swift
//  Qulpynai
//
//  Design system product card — grid and list variants
//

import SwiftUI

struct DSProductCard: View {
    let name: String
    let price: String
    var imageURL: String? = nil
    var placeholderName: String = "cup.and.saucer.fill"
    var style: Style = .grid
    let action: () -> Void

    enum Style {
        case grid
        case list
    }

    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        Button(action: action) {
            if style == .grid {
                gridLayout
            } else {
                listLayout
            }
        }
        .buttonStyle(.plain)
    }

    private var gridLayout: some View {
        VStack(alignment: .leading, spacing: DSSpacing.sm) {
            productImage
                .aspectRatio(1, contentMode: .fill)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: DSCornerRadius.medium))

            VStack(alignment: .leading, spacing: DSSpacing.xs) {
                Text(name)
                    .font(DSTypography.title)
                    .foregroundStyle(DSColors.textPrimary(theme: colorScheme))
                    .lineLimit(2)
                Text(price)
                    .font(DSTypography.bodySmall)
                    .foregroundStyle(DSColors.secondary(theme: colorScheme))
            }
        }
        .padding(DSSpacing.md)
        .background(DSColors.surface(theme: colorScheme))
        .clipShape(RoundedRectangle(cornerRadius: DSCornerRadius.medium))
        .shadow(color: .black.opacity(0.06), radius: 4, x: 0, y: 2)
    }

    private var listLayout: some View {
        HStack(spacing: DSSpacing.md) {
            productImage
                .frame(width: 80, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: DSCornerRadius.small))

            VStack(alignment: .leading, spacing: DSSpacing.xs) {
                Text(name)
                    .font(DSTypography.title)
                    .foregroundStyle(DSColors.textPrimary(theme: colorScheme))
                Text(price)
                    .font(DSTypography.bodySmall)
                    .foregroundStyle(DSColors.secondary(theme: colorScheme))
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(DSColors.textTertiary(theme: colorScheme))
        }
        .padding(DSSpacing.md)
        .background(DSColors.surface(theme: colorScheme))
        .clipShape(RoundedRectangle(cornerRadius: DSCornerRadius.medium))
    }

    @ViewBuilder
    private var productImage: some View {
        if let urlString = imageURL, let url = URL(string: urlString) {
            AsyncImage(url: url) { phase in
                switch phase {
                case .success(let image):
                    image.resizable().scaledToFill()
                case .failure:
                    placeholderView
                case .empty:
                    placeholderView
                @unknown default:
                    placeholderView
                }
            }
        } else {
            placeholderView
        }
    }

    private var placeholderView: some View {
        Image(systemName: placeholderName)
            .font(.system(size: 32))
            .foregroundStyle(DSColors.accent(theme: colorScheme))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(DSColors.surfaceVariant(theme: colorScheme))
    }
}
