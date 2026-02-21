//
//  HelpView.swift
//  Qulpynai
//

import SwiftUI

struct HelpView: View {
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DSSpacing.xl) {
                helpSection("Orders", icon: "bag.fill") {
                    Text("Track your orders in the Orders tab. Tap an order for details.")
                    Text("For pickup, show the order number at the counter.")
                }
                helpSection("Payments", icon: "creditcard.fill") {
                    Text("We accept cards and Apple Pay. Payment is processed at checkout.")
                }
                helpSection("Loyalty", icon: "star.fill") {
                    Text("Earn 10 points per dollar. Redeem 500 points for rewards.")
                }
                helpSection("Contact", icon: "envelope.fill") {
                    Text("support@qulpynai.com")
                    Text("+1 (555) 123-4567")
                }
            }
            .padding(DSSpacing.xl)
        }
        .background(DSColors.background(theme: colorScheme))
        .navigationTitle("Help")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func helpSection(_ title: String, icon: String, @ViewBuilder content: () -> some View) -> some View {
        VStack(alignment: .leading, spacing: DSSpacing.sm) {
            HStack(spacing: DSSpacing.sm) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundStyle(DSColors.secondary(theme: colorScheme))
                Text(title)
                    .font(DSTypography.subheadline)
                    .foregroundStyle(DSColors.textPrimary(theme: colorScheme))
            }
            VStack(alignment: .leading, spacing: 4) {
                content()
                    .font(DSTypography.bodySmall)
                    .foregroundStyle(DSColors.textSecondary(theme: colorScheme))
            }
            .padding(.leading, 32)
        }
        .padding(DSSpacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(DSColors.surface(theme: colorScheme))
        .clipShape(RoundedRectangle(cornerRadius: DSCornerRadius.medium))
    }
}
