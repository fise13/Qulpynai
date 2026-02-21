//
//  ProfileView.swift
//  Qulpynai
//
//  Profile — auth in profile, loyalty, settings
//

import SwiftUI

struct ProfileView: View {
    @State private var showAuthSheet = false
    @Environment(CartManager.self) private var cartManager
    @Environment(AuthManager.self) private var authManager
    @Environment(AppState.self) private var appState

    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: DSSpacing.lg) {
                    if appState.isAuthenticated {
                        loggedInHeader
                    } else {
                        guestHeader
                    }

                    if appState.isAuthenticated {
                        NavigationLink {
                            LoyaltyView()
                        } label: {
                            profileRow(icon: "giftcard.fill", title: "Loyalty", color: DSColors.secondary(theme: colorScheme))
                        }
                        .buttonStyle(.plain)
                    }

                    VStack(spacing: 0) {
                        profileRow(icon: "gearshape.fill", title: "Settings", color: DSColors.accent(theme: colorScheme))
                        Divider()
                            .padding(.leading, 56)
                        profileRow(icon: "bell.fill", title: "Notifications", color: DSColors.accent(theme: colorScheme))
                        Divider()
                            .padding(.leading, 56)
                        profileRow(icon: "questionmark.circle.fill", title: "Help", color: DSColors.accent(theme: colorScheme))
                    }
                    .background(DSColors.surface(theme: colorScheme))
                    .clipShape(RoundedRectangle(cornerRadius: DSCornerRadius.medium))

                    if appState.isAuthenticated {
                        DSButton(title: "Log Out", style: .secondary) {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                authManager.logout()
                            }
                        }
                    }
                }
                .padding(DSSpacing.xl)
            }
            .background(DSColors.background(theme: colorScheme))
            .navigationTitle("Profile")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    CartButton()
                }
            }
            .sheet(isPresented: $showAuthSheet) {
                AuthView(onDismiss: { showAuthSheet = false })
                    .environment(authManager)
            }
        }
    }

    private var guestHeader: some View {
        VStack(spacing: DSSpacing.md) {
            Image(systemName: "person.crop.circle.badge.questionmark")
                .font(.system(size: 64))
                .foregroundStyle(DSColors.accent(theme: colorScheme))
                .symbolEffect(.pulse, options: .repeating)

            Text("Sign in to save orders and earn rewards", bundle: .main)
                .font(DSTypography.body)
                .foregroundStyle(DSColors.textSecondary(theme: colorScheme))
                .multilineTextAlignment(.center)

            HStack(spacing: DSSpacing.md) {
                DSButton(title: "Log in", style: .primary, action: { showAuthSheet = true }, isFullWidth: true)
                DSButton(title: "Sign up", style: .secondary, action: { showAuthSheet = true }, isFullWidth: true)
            }
        }
        .padding(DSSpacing.xl)
        .frame(maxWidth: .infinity)
        .background(DSColors.surface(theme: colorScheme))
        .clipShape(RoundedRectangle(cornerRadius: DSCornerRadius.medium))
    }

    private var loggedInHeader: some View {
        HStack(spacing: DSSpacing.md) {
            Image(systemName: "person.circle.fill")
                .font(.system(size: 64))
                .foregroundStyle(DSColors.secondary(theme: colorScheme))
            VStack(alignment: .leading, spacing: DSSpacing.xs) {
                Text(appState.currentUser?.name ?? "User")
                    .font(DSTypography.headline)
                    .foregroundStyle(DSColors.textPrimary(theme: colorScheme))
                Text(appState.currentUser?.email ?? "user@example.com")
                    .font(DSTypography.bodySmall)
                    .foregroundStyle(DSColors.textSecondary(theme: colorScheme))
            }
            Spacer()
        }
        .padding(DSSpacing.md)
        .background(DSColors.surface(theme: colorScheme))
        .clipShape(RoundedRectangle(cornerRadius: DSCornerRadius.medium))
    }

    private func profileRow(icon: String, title: LocalizedStringKey, color: Color) -> some View {
        HStack(spacing: DSSpacing.md) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(color)
                .frame(width: 24, alignment: .center)
            Text(title)
                .font(DSTypography.body)
                .foregroundStyle(DSColors.textPrimary(theme: colorScheme))
            Spacer()
            Image(systemName: "chevron.right")
                .font(.caption.weight(.semibold))
                .foregroundStyle(DSColors.textTertiary(theme: colorScheme))
        }
        .padding(DSSpacing.md)
    }
}
