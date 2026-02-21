//
//  CartView.swift
//  Qulpynai
//
//  Cart — editable items, total, Checkout
//

import SwiftUI

struct CartView: View {
    @Environment(CartManager.self) private var cartManager
    @Environment(\.dismiss) private var dismiss

    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        NavigationStack {
            Group {
                if cartManager.items.isEmpty {
                    DSEmptyState(
                        icon: "cart",
                        title: "Your cart is empty",
                        subtitle: "Add items from the menu to get started",
                        actionTitle: "Browse Menu"
                    ) {
                        dismiss()
                    }
                } else {
                    VStack(spacing: 0) {
                        ScrollView {
                            LazyVStack(spacing: DSSpacing.sm) {
                                ForEach(cartManager.items) { item in
                                    NavigationLink(value: item) {
                                        cartItemRow(item)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(DSSpacing.xl)
                        }

                        VStack(spacing: DSSpacing.md) {
                            HStack {
                                Text("Total")
                                    .font(DSTypography.subheadline)
                                    .foregroundStyle(DSColors.textPrimary(theme: colorScheme))
                                Spacer()
                                Text(cartManager.totalFormatted)
                                    .font(DSTypography.headline)
                                    .foregroundStyle(DSColors.textPrimary(theme: colorScheme))
                            }
                            .padding(DSSpacing.md)
                            .background(DSColors.surface(theme: colorScheme))

                            DSButton(title: "Checkout", style: .primary) {
                                cartManager.isCartPresented = false
                                cartManager.isCheckoutPresented = true
                            }
                        }
                        .padding(DSSpacing.xl)
                        .background(DSColors.background(theme: colorScheme))
                    }
                }
            }
            .background(DSColors.background(theme: colorScheme))
            .navigationTitle("Cart")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundStyle(DSColors.textPrimary(theme: colorScheme))
                    }
                }
            }
            .navigationDestination(for: CartItem.self) { item in
                ProductDetailView(
                    product: item.product,
                    replaceItemId: item.id,
                    initialQuantity: item.quantity,
                    initialCustomization: item.customization
                )
            }
        }
    }

    private func cartItemRow(_ item: CartItem) -> some View {
        HStack(spacing: DSSpacing.md) {
            Image(systemName: item.product.placeholderIcon)
                .font(.title2)
                .foregroundStyle(DSColors.accent(theme: colorScheme))
                .frame(width: 48, height: 48)
                .background(DSColors.surfaceVariant(theme: colorScheme))
                .clipShape(RoundedRectangle(cornerRadius: DSCornerRadius.small))

            VStack(alignment: .leading, spacing: 2) {
                Text(String(localized: String.LocalizationValue(item.product.nameKey)))
                    .font(DSTypography.title)
                    .foregroundStyle(DSColors.textPrimary(theme: colorScheme))
                if let c = item.customization, !c.summary.isEmpty {
                    Text(c.summary)
                        .font(DSTypography.caption)
                        .foregroundStyle(DSColors.textSecondary(theme: colorScheme))
                        .lineLimit(2)
                }
                Text(item.subtotalFormatted)
                    .font(DSTypography.caption)
                    .foregroundStyle(DSColors.textSecondary(theme: colorScheme))
            }

            Spacer()

            HStack(spacing: DSSpacing.xs) {
                Button {
                    cartManager.updateQuantity(for: item.id, quantity: item.quantity - 1)
                } label: {
                    Image(systemName: "minus.circle")
                        .foregroundStyle(DSColors.primary(theme: colorScheme))
                }
                Text("\(item.quantity)")
                    .font(DSTypography.body)
                    .frame(minWidth: 20)
                    .foregroundStyle(DSColors.textPrimary(theme: colorScheme))
                Button {
                    cartManager.updateQuantity(for: item.id, quantity: item.quantity + 1)
                } label: {
                    Image(systemName: "plus.circle")
                        .foregroundStyle(DSColors.primary(theme: colorScheme))
                }
            }
        }
        .padding(DSSpacing.md)
        .background(DSColors.surface(theme: colorScheme))
        .clipShape(RoundedRectangle(cornerRadius: DSCornerRadius.medium))
    }
}
