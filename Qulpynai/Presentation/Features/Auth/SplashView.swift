//
//  SplashView.swift
//  Qulpynai
//
//  Splash screen — logo, brand name, animations
//

import SwiftUI

struct SplashView: View {
    @State private var logoScale: CGFloat = 0.5
    @State private var logoOpacity: Double = 0
    @State private var titleOpacity: Double = 0
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        ZStack {
            DSColors.background(theme: colorScheme)
                .ignoresSafeArea()

            VStack(spacing: DSSpacing.xl) {
                Image(systemName: "cup.and.saucer.fill")
                    .font(.system(size: 72))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [
                                DSColors.secondary(theme: colorScheme),
                                DSColors.accent(theme: colorScheme)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .scaleEffect(logoScale)
                    .opacity(logoOpacity)

                Text("Qulpynai")
                    .font(DSTypography.display)
                    .foregroundStyle(DSColors.textPrimary(theme: colorScheme))
                    .opacity(titleOpacity)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                logoScale = 1
                logoOpacity = 1
            }
            withAnimation(.easeOut(duration: 0.5).delay(0.25)) {
                titleOpacity = 1
            }
        }
    }
}
