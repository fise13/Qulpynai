//
//  CartButton.swift
//  Qulpynai
//
//  Custom pill cart button — text + count, non‑Apple style
//

import SwiftUI

struct CartButton: View {
    @Environment(CartManager.self) private var cartManager
    @State private var pulse = false

    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        Button {
            cartManager.isCartPresented = true
        } label: {
            HStack(spacing: 6) {
                Image(systemName: "basket.fill")
                    .font(.system(size: 14, weight: .medium))
                Text("Корзина")
                    .font(.system(size: 14, weight: .semibold))
                if cartManager.itemCount > 0 {
                    Text("\(cartManager.itemCount)")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(DSColors.textPrimary(theme: colorScheme))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(DSColors.secondary(theme: colorScheme).opacity(0.3))
                        .clipShape(Capsule())
                        .scaleEffect(pulse ? 1.1 : 1)
                }
            }
            .foregroundStyle(DSColors.textPrimary(theme: colorScheme))
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(DSColors.surface(theme: colorScheme))
            .clipShape(RoundedRectangle(cornerRadius: DSCornerRadius.medium))
            .overlay(
                RoundedRectangle(cornerRadius: DSCornerRadius.medium)
                    .stroke(DSColors.divider(theme: colorScheme), lineWidth: 1)
            )
        }
        .buttonStyle(ScaleButtonStyle())
        .onChange(of: cartManager.itemCount) { _, _ in
            withAnimation(.spring(response: 0.25, dampingFraction: 0.6)) { pulse = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) { pulse = false }
            }
        }
    }
}
