//
//  HomeView.swift
//  Qulpynai
//
//  Home — promo banner, featured (FetchMenuUseCase), quick reorder (OrderManager)
//

import SwiftUI

struct HomeView: View {
    @Environment(CartManager.self) private var cartManager
    @Environment(OrderManager.self) private var orderManager
    @Environment(AdminStore.self) private var adminStore
    @Environment(\.appEnvironment) private var appEnv
    @State private var featuredProducts: [Product] = []
    @State private var quickReorderItems: [CartItem] = []
    @State private var isLoading = false

    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        NavigationStack {
            content
                .background(DSColors.background(theme: colorScheme))
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Главная")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundStyle(DSColors.textPrimary(theme: colorScheme))
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        CartButton()
                    }
                }
                .navigationDestination(for: Product.self) { product in
                    ProductDetailView(product: product)
                }
                .task(id: adminStore.useAdminData) {
                    await loadData()
                }
        }
    }

    @ViewBuilder
    private var content: some View {
        if isLoading && featuredProducts.isEmpty {
            DSLoadingState()
        } else {
            ScrollView {
                VStack(alignment: .leading, spacing: DSSpacing.lg) {
                    promoBanner

                    VStack(alignment: .leading, spacing: DSSpacing.md) {
                        Text("Популярное")
                            .font(DSTypography.subheadline)
                            .foregroundStyle(DSColors.textPrimary(theme: colorScheme))

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: DSSpacing.md) {
                                ForEach(featuredProducts) { product in
                                    NavigationLink(value: product) {
                                        HomeProductCard(
                                            name: String(localized: String.LocalizationValue(product.nameKey)),
                                            price: product.priceFormatted,
                                            imageURL: product.imageURL,
                                            placeholderName: product.placeholderIcon
                                        )
                                    }
                                    .buttonStyle(ScaleButtonStyle())
                                    .frame(width: 150)
                                }
                            }
                        }
                    }

                    if !quickReorderItems.isEmpty {
                        VStack(alignment: .leading, spacing: DSSpacing.md) {
                            Text("Повторить заказ")
                                .font(DSTypography.subheadline)
                                .foregroundStyle(DSColors.textPrimary(theme: colorScheme))

                            VStack(spacing: DSSpacing.sm) {
                                ForEach(quickReorderItems) { item in
                                    HStack {
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(String(localized: String.LocalizationValue(item.product.nameKey)))
                                                .font(DSTypography.title)
                                                .foregroundStyle(DSColors.textPrimary(theme: colorScheme))
                                            Text("\(item.quantity) × \(item.product.priceFormatted)")
                                                .font(DSTypography.caption)
                                                .foregroundStyle(DSColors.textSecondary(theme: colorScheme))
                                        }
                                        Spacer()
                                        Button {
                                            cartManager.add(item.product, quantity: item.quantity, customization: item.customization)
                                        } label: {
                                            Text("Заказать")
                                                .font(DSTypography.caption)
                                                .foregroundStyle(DSColors.secondary(theme: colorScheme))
                                        }
                                        .buttonStyle(ScaleButtonStyle())
                                    }
                                    .padding(DSSpacing.md)
                                    .background(DSColors.surface(theme: colorScheme))
                                    .clipShape(RoundedRectangle(cornerRadius: DSCornerRadius.medium))
                                }
                            }
                        }
                    }
                }
                .padding(DSSpacing.xl)
            }
        }
    }

    private var promoBanner: some View {
        let banner = adminStore.useAdminData ? adminStore.promoBanner : AdminPromoBanner(title: "20% на первый заказ", subtitle: "Используйте код WELCOME20 при оформлении", code: "WELCOME20")
        return HStack(spacing: DSSpacing.md) {
            Image(systemName: "tag.fill")
                .font(.title2)
                .foregroundStyle(.white)

            VStack(alignment: .leading, spacing: 4) {
                Text(banner.title)
                    .font(DSTypography.title)
                    .foregroundStyle(.white)
                Text(banner.subtitle)
                    .font(DSTypography.caption)
                    .foregroundStyle(.white.opacity(0.95))
            }

            Spacer()
            Image(systemName: "chevron.right")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.white.opacity(0.9))
        }
        .padding(DSSpacing.lg)
        .background(
            LinearGradient(
                colors: [
                    DSColors.secondary(theme: colorScheme),
                    DSColors.accent(theme: colorScheme)
                ],
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: DSCornerRadius.large))
    }

    private func loadData() async {
        if adminStore.useAdminData {
            await MainActor.run {
                featuredProducts = adminStore.featuredProducts
                quickReorderItems = []
            }
            isLoading = false
            return
        }
        guard let env = appEnv else { return }
        isLoading = true
        do {
            let prods = try await env.fetchMenuUseCase.executeProducts()
            let orders = try await orderManager.fetchOrderHistory()
            await MainActor.run {
                featuredProducts = Array(prods.prefix(4))
                quickReorderItems = orders.first?.items ?? []
            }
        } catch {
            await MainActor.run {
                featuredProducts = []
                quickReorderItems = []
            }
        }
        isLoading = false
    }
}

// MARK: - Home Product Card

private struct HomeProductCard: View {
    let name: String
    let price: String
    var imageURL: String? = nil
    let placeholderName: String

    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.sm) {
            Group {
                if let urlString = imageURL, let url = URL(string: urlString) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let img): img.resizable().scaledToFill()
                        default:
                            Image(systemName: placeholderName)
                                .font(.system(size: 40))
                                .foregroundStyle(DSColors.secondary(theme: colorScheme))
                        }
                    }
                } else {
                    Image(systemName: placeholderName)
                        .font(.system(size: 40))
                        .foregroundStyle(DSColors.secondary(theme: colorScheme))
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 100)
            .background(DSColors.surfaceVariant(theme: colorScheme))
            .clipShape(RoundedRectangle(cornerRadius: DSCornerRadius.medium))

            Text(name)
                .font(DSTypography.title)
                .foregroundStyle(DSColors.textPrimary(theme: colorScheme))
                .lineLimit(2)
            Text(price)
                .font(DSTypography.bodySmall)
                .foregroundStyle(DSColors.textSecondary(theme: colorScheme))
        }
        .padding(DSSpacing.md)
        .background(DSColors.surface(theme: colorScheme))
        .clipShape(RoundedRectangle(cornerRadius: DSCornerRadius.medium))
    }
}
