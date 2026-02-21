//
//  CartButton.swift
//  Qulpynai
//
//  Global cart button with badge
//

import SwiftUI

struct CartButton: View {
    @Environment(CartManager.self) private var cartManager
    @State private var badgePulse = false

    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        Button {
            cartManager.isCartPresented = true
        } label: {
            ZStack(alignment: .topTrailing) {
                Image(systemName: "cart.fill")
                    .font(.title2)
                    .foregroundStyle(DSColors.primary(theme: colorScheme))
                DSBadge(count: cartManager.itemCount)
                    .offset(x: 8, y: -8)
                    .scaleEffect(badgePulse ? 1.2 : 1)
            }
        }
        .buttonStyle(ScaleButtonStyle())
        .onChange(of: cartManager.itemCount) { _, _ in
            withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                badgePulse = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    badgePulse = false
                }
            }
        }
    }
}
