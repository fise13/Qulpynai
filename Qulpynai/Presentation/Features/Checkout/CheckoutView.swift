//
//  CheckoutView.swift
//  Qulpynai
//
//  Checkout — uses CreateOrderUseCase
//

import SwiftUI

struct CheckoutView: View {
    @Environment(CartManager.self) private var cartManager
    @Environment(AuthManager.self) private var authManager
    @Environment(AppState.self) private var appState
    @Environment(\.appEnvironment) private var appEnv
    @Environment(\.dismiss) private var dismiss
    @State private var showAuthSheet = false
    @State private var deliveryOption = "delivery"
    @AppStorage("qulpynai_last_address") private var address = ""
    @State private var showOrderSuccess = false
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var createdOrder: Order?
    @State private var promoCode = ""
    @State private var promoError: String?

    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: DSSpacing.lg) {
                    if !appState.isAuthenticated {
                        Button {
                            showAuthSheet = true
                        } label: {
                            HStack(spacing: DSSpacing.sm) {
                                Image(systemName: "star.circle.fill")
                                    .foregroundStyle(DSColors.secondary(theme: colorScheme))
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Sign in to earn points", bundle: .main)
                                        .font(DSTypography.title)
                                        .foregroundStyle(DSColors.textPrimary(theme: colorScheme))
                                    Text("Get rewards on this order", bundle: .main)
                                        .font(DSTypography.caption)
                                        .foregroundStyle(DSColors.textSecondary(theme: colorScheme))
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundStyle(DSColors.textTertiary(theme: colorScheme))
                            }
                            .padding(DSSpacing.md)
                            .background(DSColors.surfaceVariant(theme: colorScheme))
                            .clipShape(RoundedRectangle(cornerRadius: DSCornerRadius.medium))
                        }
                        .buttonStyle(.plain)
                    }

                    if let error = errorMessage {
                        Text(error)
                            .font(DSTypography.caption)
                            .foregroundStyle(DSColors.error(theme: colorScheme))
                    }

                    VStack(alignment: .leading, spacing: DSSpacing.sm) {
                        Text("Delivery or Pickup")
                            .font(DSTypography.subheadline)
                            .foregroundStyle(DSColors.textPrimary(theme: colorScheme))

                        HStack(spacing: DSSpacing.md) {
                            deliveryOptionButton("delivery", title: String(localized: "Delivery"), icon: "car.fill")
                            deliveryOptionButton("pickup", title: String(localized: "Pickup"), icon: "storefront.fill")
                        }
                    }

                    VStack(alignment: .leading, spacing: DSSpacing.sm) {
                        Text("Promo Code")
                            .font(DSTypography.subheadline)
                            .foregroundStyle(DSColors.textPrimary(theme: colorScheme))
                        HStack(spacing: DSSpacing.sm) {
                            DSInput(placeholder: "WELCOME10", text: $promoCode, icon: "tag.fill")
                            if let promo = cartManager.appliedPromotion {
                                Text(promo.code)
                                    .font(DSTypography.caption)
                                    .foregroundStyle(DSColors.secondary(theme: colorScheme))
                            } else {
                                Button("Apply") {
                                    Task { await applyPromo() }
                                }
                                .font(DSTypography.body)
                                .foregroundStyle(DSColors.primary(theme: colorScheme))
                            }
                        }
                        if let err = promoError {
                            Text(err)
                                .font(.caption2)
                                .foregroundStyle(DSColors.error(theme: colorScheme))
                        }
                    }

                    VStack(alignment: .leading, spacing: DSSpacing.sm) {
                        Text("Address")
                            .font(DSTypography.subheadline)
                            .foregroundStyle(DSColors.textPrimary(theme: colorScheme))
                        DSInput(placeholder: "123 Main St, New York, NY", text: $address, icon: "mappin")
                    }

                    VStack(alignment: .leading, spacing: DSSpacing.sm) {
                        Text("Payment")
                            .font(DSTypography.subheadline)
                            .foregroundStyle(DSColors.textPrimary(theme: colorScheme))
                        HStack {
                            Image(systemName: "creditcard.fill")
                                .foregroundStyle(DSColors.secondary(theme: colorScheme))
                            Text("•••• 4242")
                                .font(DSTypography.body)
                                .foregroundStyle(DSColors.textPrimary(theme: colorScheme))
                            Spacer()
                        }
                        .padding(DSSpacing.md)
                        .background(DSColors.surfaceVariant(theme: colorScheme))
                        .clipShape(RoundedRectangle(cornerRadius: DSCornerRadius.medium))
                    }

                    VStack(alignment: .leading, spacing: DSSpacing.sm) {
                        Text("Order Summary")
                            .font(DSTypography.subheadline)
                            .foregroundStyle(DSColors.textPrimary(theme: colorScheme))
                        ForEach(cartManager.items) { item in
                            VStack(alignment: .leading, spacing: 2) {
                                HStack {
                                    Text("\(item.quantity)× \(String(localized: String.LocalizationValue(item.product.nameKey)))")
                                        .font(DSTypography.bodySmall)
                                        .foregroundStyle(DSColors.textSecondary(theme: colorScheme))
                                    Spacer()
                                    Text(item.subtotalFormatted)
                                        .font(DSTypography.bodySmall)
                                        .foregroundStyle(DSColors.textPrimary(theme: colorScheme))
                                }
                                if let c = item.customization, !c.summary.isEmpty {
                                    Text(c.summary)
                                        .font(.caption2)
                                        .foregroundStyle(DSColors.textTertiary(theme: colorScheme))
                                }
                            }
                        }
                        if cartManager.discountAmount > 0 {
                            HStack {
                                Text("Discount")
                                    .font(DSTypography.bodySmall)
                                    .foregroundStyle(DSColors.secondary(theme: colorScheme))
                                Spacer()
                                Text("-\(formatPrice(cartManager.discountAmount))")
                                    .font(DSTypography.bodySmall)
                                    .foregroundStyle(DSColors.secondary(theme: colorScheme))
                            }
                        }
                        Divider()
                        HStack {
                            Text("Total")
                                .font(DSTypography.title)
                                .foregroundStyle(DSColors.textPrimary(theme: colorScheme))
                            Spacer()
                            Text(cartManager.totalFormatted)
                                .font(DSTypography.headline)
                                .foregroundStyle(DSColors.textPrimary(theme: colorScheme))
                        }
                    }
                    .padding(DSSpacing.md)
                    .background(DSColors.surface(theme: colorScheme))
                    .clipShape(RoundedRectangle(cornerRadius: DSCornerRadius.medium))

                    DSButton(title: "Place Order", style: isLoading ? .disabled : .primary) {
                        Task { await placeOrder() }
                    }
                    .disabled(isLoading)
                }
                .padding(DSSpacing.xl)
            }
            .background(DSColors.background(theme: colorScheme))
            .navigationTitle("Checkout")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundStyle(DSColors.textTertiary(theme: colorScheme))
                    }
                }
            }
            .sheet(isPresented: $showAuthSheet) {
                AuthView(onDismiss: { showAuthSheet = false })
                    .environment(authManager)
            }
            .fullScreenCover(isPresented: $showOrderSuccess) {
                OrderSuccessView(order: createdOrder ?? createPlaceholderOrder(), onDismiss: {
                    showOrderSuccess = false
                    dismiss()
                })
            }
        }
    }

    private func placeOrder() async {
        guard let env = appEnv else { return }
        let option: DeliveryOption = deliveryOption == "pickup" ? .pickup : .delivery
        if option == .delivery && address.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errorMessage = "Please enter delivery address"
            return
        }
        isLoading = true
        errorMessage = nil
        do {
            let order = try await env.createOrderUseCase.execute(
                deliveryOption: option,
                address: address,
                paymentMethodId: "card_4242",
                userId: appState.currentUser?.id
            )
            await MainActor.run {
                createdOrder = order
                showOrderSuccess = true
            }
        } catch {
            await MainActor.run {
                errorMessage = error.localizedDescription
            }
        }
        isLoading = false
    }

    private func createPlaceholderOrder() -> Order {
        Order(
            id: UUID().uuidString,
            orderNumber: "#\(Int.random(in: 1000...9999))",
            date: Date(),
            status: .confirmed,
            items: cartManager.items,
            total: cartManager.total,
            userId: nil
        )
    }

    private func formatPrice(_ value: Decimal) -> String {
        let f = NumberFormatter()
        f.numberStyle = .currency
        f.currencyCode = "USD"
        return f.string(from: value as NSDecimalNumber) ?? "$\(value)"
    }

    private func applyPromo() async {
        guard let env = appEnv else { return }
        let code = promoCode.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !code.isEmpty else {
            promoError = "Enter a promo code"
            return
        }
        promoError = nil
        do {
            if let promo = try await env.applyPromotionUseCase.execute(code: code, cartTotal: cartManager.subtotal) {
                let discount = env.applyPromotionUseCase.calculateDiscount(promotion: promo, cartTotal: cartManager.subtotal)
                cartManager.applyPromotion(promo, discount: discount)
            } else {
                promoError = "Invalid or expired code"
            }
        } catch {
            promoError = error.localizedDescription
        }
    }

    private func deliveryOptionButton(_ id: String, title: String, icon: String) -> some View {
        Button {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                deliveryOption = id
            }
        } label: {
            HStack {
                Image(systemName: icon)
                Text(title)
            }
            .font(DSTypography.body)
            .frame(maxWidth: .infinity)
            .padding(DSSpacing.md)
            .foregroundStyle(deliveryOption == id ? DSColors.surface : DSColors.textPrimary(theme: colorScheme))
            .background(deliveryOption == id ? DSColors.primary(theme: colorScheme) : DSColors.surfaceVariant(theme: colorScheme))
            .clipShape(RoundedRectangle(cornerRadius: DSCornerRadius.medium))
        }
        .buttonStyle(ScaleButtonStyle())
    }
}
