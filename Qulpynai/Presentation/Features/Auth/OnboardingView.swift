//
//  OnboardingView.swift
//  Qulpynai
//
//  Onboarding — 3 screens, swipe + skip, animations
//

import SwiftUI

struct OnboardingView: View {
    @Binding var hasCompletedOnboarding: Bool
    @State private var currentPage = 0
    @State private var iconScale: CGFloat = 0.8
    @State private var contentOpacity: Double = 0

    @Environment(\.colorScheme) private var colorScheme

    private let pages: [(icon: String, titleKey: LocalizedStringKey, subtitleKey: LocalizedStringKey)] = [
        ("cup.and.saucer.fill", "onboarding_1_title", "onboarding_1_subtitle"),
        ("leaf.fill", "onboarding_2_title", "onboarding_2_subtitle"),
        ("heart.fill", "onboarding_3_title", "onboarding_3_subtitle")
    ]

    var body: some View {
        ZStack(alignment: .topTrailing) {
            DSColors.background(theme: colorScheme)
                .ignoresSafeArea()

            VStack(spacing: DSSpacing.xxl) {
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        VStack(spacing: DSSpacing.xl) {
                            Image(systemName: pages[index].icon)
                                .font(.system(size: 72))
                                .foregroundStyle(DSColors.secondary(theme: colorScheme))
                                .scaleEffect(currentPage == index ? iconScale : 0.8)
                                .opacity(currentPage == index ? 1 : 0.5)
                                .animation(.spring(response: 0.5, dampingFraction: 0.7), value: currentPage)

                            VStack(spacing: DSSpacing.sm) {
                                Text(pages[index].titleKey)
                                    .font(DSTypography.headline)
                                    .foregroundStyle(DSColors.textPrimary(theme: colorScheme))
                                    .multilineTextAlignment(.center)

                                Text(pages[index].subtitleKey)
                                    .font(DSTypography.body)
                                    .foregroundStyle(DSColors.textSecondary(theme: colorScheme))
                                    .multilineTextAlignment(.center)
                            }
                        }
                        .padding(DSSpacing.xl)
                        .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .always))

                VStack(spacing: DSSpacing.md) {
                    DSButton(
                        title: currentPage == pages.count - 1 ? "Get Started" : "Continue",
                        style: .primary
                    ) {
                        if currentPage == pages.count - 1 {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                                hasCompletedOnboarding = true
                            }
                        } else {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                currentPage += 1
                            }
                        }
                    }
                }
                .padding(.horizontal, DSSpacing.xl)
                .padding(.bottom, DSSpacing.xxl)
            }

            Button {
                withAnimation(.easeInOut(duration: 0.3)) {
                    hasCompletedOnboarding = true
                }
            } label: {
                Text("Skip")
                    .font(DSTypography.bodySmall)
                    .foregroundStyle(DSColors.textSecondary(theme: colorScheme))
            }
            .padding(DSSpacing.lg)
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                iconScale = 1
                contentOpacity = 1
            }
        }
    }
}
