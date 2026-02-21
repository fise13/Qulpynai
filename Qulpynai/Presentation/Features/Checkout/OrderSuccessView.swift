//
//  OrderSuccessView.swift
//  Qulpynai
//
//  Order success — confirmation screen
//

import SwiftUI

struct OrderSuccessView: View {
    let order: Order?
    let onDismiss: () -> Void
    private var orderNumber: String { order?.orderNumber ?? "#\(Int.random(in: 1000...9999))" }
    @State private var iconScale: CGFloat = 0
    @State private var contentOpacity: Double = 0

    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(spacing: DSSpacing.xl) {
            Spacer()
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 88))
                .foregroundStyle(DSColors.success(theme: colorScheme))
                .scaleEffect(iconScale)

            VStack(spacing: DSSpacing.sm) {
                Text("Order Confirmed!")
                    .font(DSTypography.headline)
                    .foregroundStyle(DSColors.textPrimary(theme: colorScheme))
                Text("Order \(orderNumber)")
                    .font(DSTypography.body)
                    .foregroundStyle(DSColors.textSecondary(theme: colorScheme))
            }

            Spacer()

            DSButton(title: "Back to Home", style: .primary) {
                onDismiss()
            }
            .padding(.horizontal, DSSpacing.xl)
            .padding(.bottom, DSSpacing.xxl)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(DSColors.background(theme: colorScheme))
        .opacity(contentOpacity)
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                iconScale = 1
            }
            withAnimation(.easeOut(duration: 0.4)) {
                contentOpacity = 1
            }
        }
    }
}
