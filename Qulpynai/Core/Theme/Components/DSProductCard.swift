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
    var action: (() -> Void)? = nil

    enum Style {
        case grid
        case list
    }

    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        Group {
            if let action {
                Button(action: action) { cardContent }
                    .buttonStyle(ScaleButtonStyle())
            } else {
                cardContent
            }
        }
    }

    @ViewBuilder
    private var cardContent: some View {
        if style == .grid {
            gridLayout
        } else {
            listLayout
        }
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
        .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
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
