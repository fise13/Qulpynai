//
//  OrderDetailView.swift
//  Qulpynai
//
//  Order detail screen
//

import SwiftUI

struct OrderDetailView: View {
    let order: Order

    @Environment(\.colorScheme) private var colorScheme

    private let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .long
        f.timeStyle = .short
        return f
    }()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DSSpacing.lg) {
                DSCard {
                    VStack(alignment: .leading, spacing: DSSpacing.sm) {
                        HStack {
                            Text("Order \(order.orderNumber)")
                                .font(DSTypography.headline)
                                .foregroundStyle(DSColors.textPrimary(theme: colorScheme))
                            Spacer()
                            Text(statusText(order.status))
                                .font(DSTypography.captionSmall)
                                .foregroundStyle(DSColors.surface)
                                .padding(.horizontal, DSSpacing.sm)
                                .padding(.vertical, DSSpacing.xs)
                                .background(DSColors.success(theme: colorScheme))
                                .clipShape(Capsule())
                        }
                        Text(dateFormatter.string(from: order.date))
                            .font(DSTypography.caption)
                            .foregroundStyle(DSColors.textSecondary(theme: colorScheme))
                    }
                }

                VStack(alignment: .leading, spacing: DSSpacing.sm) {
                    Text("Items")
                        .font(DSTypography.subheadline)
                        .foregroundStyle(DSColors.textPrimary(theme: colorScheme))

                    ForEach(order.items) { item in
                        VStack(alignment: .leading, spacing: 2) {
                            HStack {
                                Text("\(item.quantity)× \(String(localized: String.LocalizationValue(item.product.nameKey)))")
                                    .font(DSTypography.body)
                                    .foregroundStyle(DSColors.textSecondary(theme: colorScheme))
                                Spacer()
                                Text(item.subtotalFormatted)
                                    .font(DSTypography.body)
                                    .foregroundStyle(DSColors.textPrimary(theme: colorScheme))
                            }
                            if let c = item.customization, !c.summary.isEmpty {
                                Text(c.summary)
                                    .font(.caption2)
                                    .foregroundStyle(DSColors.textTertiary(theme: colorScheme))
                            }
                        }
                    }
                    Divider()
                    HStack {
                        Text("Total")
                            .font(DSTypography.title)
                            .foregroundStyle(DSColors.textPrimary(theme: colorScheme))
                        Spacer()
                        Text(order.totalFormatted)
                            .font(DSTypography.headline)
                            .foregroundStyle(DSColors.textPrimary(theme: colorScheme))
                    }
                }
                .padding(DSSpacing.md)
                .background(DSColors.surface(theme: colorScheme))
                .clipShape(RoundedRectangle(cornerRadius: DSCornerRadius.medium))
            }
            .padding(DSSpacing.xl)
        }
        .background(DSColors.background(theme: colorScheme))
        .navigationTitle("Order Details")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func statusText(_ status: Order.OrderStatus) -> String {
        switch status {
        case .pending: return String(localized: "status_pending")
        case .confirmed: return String(localized: "status_confirmed")
        case .preparing: return String(localized: "status_preparing")
        case .ready: return String(localized: "status_ready")
        case .delivered: return String(localized: "status_delivered")
        case .failed: return "Failed"
        }
    }
}
