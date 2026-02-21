//
//  LoyaltyView.swift
//  Qulpynai
//
//  Loyalty / Wallet preview mock
//

import SwiftUI

struct LoyaltyView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.colorScheme) private var colorScheme

    private var pointsToNextReward: Int { 500 - (appState.loyaltyBalance % 500) }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DSSpacing.lg) {
                DSCard(elevated: true) {
                    VStack(alignment: .leading, spacing: DSSpacing.md) {
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundStyle(DSColors.secondary(theme: colorScheme))
                            Text("Points Balance")
                                .font(DSTypography.subheadline)
                                .foregroundStyle(DSColors.textSecondary(theme: colorScheme))
                            Spacer()
                        }
                        Text(NumberFormatter.localizedString(from: NSNumber(value: appState.loyaltyBalance), number: .decimal))
                            .font(.system(size: 36, weight: .bold))
                            .foregroundStyle(DSColors.textPrimary(theme: colorScheme))
                        Text("\(pointsToNextReward) points until next reward")
                            .font(DSTypography.caption)
                            .foregroundStyle(DSColors.textSecondary(theme: colorScheme))
                    }
                }

                VStack(alignment: .leading, spacing: DSSpacing.sm) {
                    Text("Available Offers")
                        .font(DSTypography.subheadline)
                        .foregroundStyle(DSColors.textPrimary(theme: colorScheme))

                    DSBanner(
                        title: "Free coffee on your birthday",
                        subtitle: "Redeem 500 points",
                        icon: "birthday.cake.fill",
                        style: .promo
                    ) {}
                }
            }
            .padding(DSSpacing.xl)
        }
        .background(DSColors.background(theme: colorScheme))
        .navigationTitle("Loyalty")
        .navigationBarTitleDisplayMode(.inline)
    }
}
