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
    @Environment(\.appEnvironment) private var appEnv
    @State private var featuredProducts: [Product] = []
    @State private var quickReorderItems: [CartItem] = []
    @State private var isLoading = false

    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        NavigationStack {
            content
                .background(DSColors.background(theme: colorScheme))
                .navigationTitle("Home")
                .navigationDestination(for: Product.self) { product in
                    ProductDetailView(product: product)
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        CartButton()
                    }
                }
                .task {
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
                    DSBanner(
                        title: String(localized: "promo_title"),
                        subtitle: String(localized: "promo_subtitle"),
                        icon: "tag.fill",
                        style: .promo
                    ) {}

                    VStack(alignment: .leading, spacing: DSSpacing.md) {
                        Text("Featured")
                            .font(DSTypography.subheadline)
                            .foregroundStyle(DSColors.textPrimary(theme: colorScheme))

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: DSSpacing.md) {
                                ForEach(Array(featuredProducts.enumerated()), id: \.element.id) { _, product in
                                    NavigationLink(value: product) {
                                        DSProductCard(
                                            name: String(localized: String.LocalizationValue(product.nameKey)),
                                            price: product.priceFormatted,
                                            imageURL: product.imageURL,
                                            placeholderName: product.placeholderIcon,
                                            style: .grid
                                        ) {}
                                    }
                                    .buttonStyle(.plain)
                                    .frame(width: 160)
                                }
                            }
                        }
                    }

                    if !quickReorderItems.isEmpty {
                        VStack(alignment: .leading, spacing: DSSpacing.md) {
                            Text("Quick Reorder")
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
                                            Text("Reorder")
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

    private func loadData() async {
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
