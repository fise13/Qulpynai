//
//  MenuView.swift
//  Qulpynai
//
//  Menu — category chips, product grid (FetchMenuUseCase)
//

import SwiftUI

struct MenuView: View {
    @Environment(CartManager.self) private var cartManager
    @Environment(AppState.self) private var appState
    @Environment(\.appEnvironment) private var appEnv
    @State private var categories: [Category] = []
    @State private var products: [Product] = []
    @State private var locations: [Location] = []
    @State private var selectedCategoryId = "all"
    @State private var isLoading = false
    @State private var loadError: String?

    @Environment(\.colorScheme) private var colorScheme

    private var filteredProducts: [Product] {
        guard !products.isEmpty else { return products }
        if selectedCategoryId == "all" { return products }
        return products.filter { $0.categoryId == selectedCategoryId }
    }

    var body: some View {
        NavigationStack {
            Group {
                if isLoading && categories.isEmpty {
                    DSLoadingState()
                } else if let err = loadError {
                    DSEmptyState(icon: "exclamationmark.triangle", title: "Error", subtitle: LocalizedStringKey(stringLiteral: err))
                } else {
                    ScrollView {
                        VStack(alignment: .leading, spacing: DSSpacing.lg) {
                            LocationSelectorView(
                                locations: locations,
                                selectedLocation: Binding(
                                    get: { appState.selectedLocation },
                                    set: { appState.selectedLocation = $0 }
                                ),
                                colorScheme: colorScheme
                            )

                            VStack(alignment: .leading, spacing: DSSpacing.sm) {
                                Text("Categories")
                                    .font(DSTypography.subheadline)
                                    .foregroundStyle(DSColors.textPrimary(theme: colorScheme))

                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: DSSpacing.sm) {
                                        ForEach(categories) { category in
                                            DSChip(
                                                title: String(localized: String.LocalizationValue(category.nameKey)),
                                                isSelected: selectedCategoryId == category.id
                                            ) {
                                                withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                                                    selectedCategoryId = category.id
                                                }
                                            }
                                        }
                                    }
                                }
                            }

                            LazyVGrid(columns: [
                                GridItem(.flexible(), spacing: DSSpacing.md),
                                GridItem(.flexible(), spacing: DSSpacing.md)
                            ], spacing: DSSpacing.md) {
                                ForEach(filteredProducts) { product in
                                    NavigationLink(value: product) {
                                        DSProductCard(
                                            name: String(localized: String.LocalizationValue(product.nameKey)),
                                            price: product.priceFormatted,
                                            imageURL: product.imageURL,
                                            placeholderName: product.placeholderIcon,
                                            style: .grid
                                        )
                                    }
                                    .disabled(product.isOutOfStock)
                                }
                            }
                        }
                        .padding(DSSpacing.xl)
                    }
                }
            }
            .background(DSColors.background(theme: colorScheme))
            .navigationTitle("Menu")
            .navigationDestination(for: Product.self) { product in
                ProductDetailView(product: product)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    CartButton()
                }
            }
            .task {
                await loadMenu()
            }
            .refreshable {
                await loadMenu()
            }
        }
    }

    private func loadMenu() async {
        guard let env = appEnv else { return }
        isLoading = true
        loadError = nil
        do {
            async let cats = env.fetchMenuUseCase.executeCategories(locationId: appState.selectedLocation?.id)
            async let prods = env.fetchMenuUseCase.executeProducts(locationId: appState.selectedLocation?.id)
            let locs = try? await env.fetchLocationsUseCase.execute()
            let (c, p) = try await (cats, prods)
            await MainActor.run {
                categories = c
                products = p
                locations = locs ?? []
            }
        } catch {
            await MainActor.run {
                loadError = error.localizedDescription
            }
        }
        isLoading = false
    }
}
