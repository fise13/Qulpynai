//
//  ProductDetailView.swift
//  Qulpynai
//
//  Product detail — hero image, customization, add to cart
//

import SwiftUI

struct ProductDetailView: View {
    let product: Product
    var replaceItemId: String? = nil
    @Environment(CartManager.self) private var cartManager
    @State private var quantity: Int
    @State private var addedToCart = false
    @State private var heroScale: CGFloat = 0.98
    @State private var contentOpacity: Double = 0

    @State private var selectedSize: String?
    @State private var selectedMilk: String?
    @State private var selectedExtras: Set<String> = []
    @State private var notes: String

    @Environment(\.colorScheme) private var colorScheme

    init(product: Product, replaceItemId: String? = nil, initialQuantity: Int = 1, initialCustomization: ProductCustomization? = nil) {
        self.product = product
        self.replaceItemId = replaceItemId
        _quantity = State(initialValue: initialQuantity)
        _notes = State(initialValue: initialCustomization?.notes ?? "")
        _selectedSize = State(initialValue: initialCustomization?.size)
        _selectedMilk = State(initialValue: initialCustomization?.milk)
        _selectedExtras = State(initialValue: Set(initialCustomization?.extras ?? []))
    }

    private var isDrink: Bool { product.categoryId == "drinks" }

    private var customization: ProductCustomization {
        var c = ProductCustomization()
        if isDrink {
            c.size = selectedSize
            c.milk = selectedMilk
            c.extras = Array(selectedExtras)
        }
        c.notes = notes.trimmingCharacters(in: .whitespacesAndNewlines)
        return c
    }

    private var unitPrice: Decimal {
        product.price + CustomizationOptions.priceModifier(
            size: customization.size,
            milk: customization.milk,
            extras: customization.extras
        )
    }

    private var totalPrice: Decimal { unitPrice * Decimal(quantity) }

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(spacing: 0) {
                    heroSection

                    VStack(alignment: .leading, spacing: DSSpacing.lg) {
                        infoSection

                        if isDrink {
                            sizeSection
                            milkSection
                            addOnsSection
                        }

                        notesSection
                        quantitySection
                    }
                    .padding(DSSpacing.xl)
                    .opacity(contentOpacity)
                }
                .padding(.bottom, 100)
            }

            stickyAddToCartBar
        }
        .background(DSColors.background(theme: colorScheme))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                CartButton()
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.85)) {
                heroScale = 1
            }
            withAnimation(.easeOut(duration: 0.4).delay(0.15)) {
                contentOpacity = 1
            }
        }
    }

    // MARK: - Hero

    private var heroSection: some View {
        ZStack(alignment: .bottomLeading) {
            productHeroImage
                .overlay(heroGradient)
                .overlay(outOfStockOverlay)

            VStack(alignment: .leading, spacing: DSSpacing.xs) {
                Text(String(localized: String.LocalizationValue(product.nameKey)))
                    .font(.system(size: 28, weight: .bold, design: .serif))
                    .foregroundStyle(.white)
                    .shadow(color: .black.opacity(0.4), radius: 4, x: 0, y: 2)

                HStack(spacing: DSSpacing.sm) {
                    Text(priceText)
                        .font(DSTypography.subheadline)
                        .foregroundStyle(.white.opacity(0.95))
                }
            }
            .padding(DSSpacing.xl)
        }
        .frame(height: 220)
        .clipShape(RoundedRectangle(cornerRadius: DSCornerRadius.large))
        .scaleEffect(heroScale)
        .padding(.horizontal, DSSpacing.xl)
        .padding(.top, DSSpacing.sm)
        .padding(.bottom, DSSpacing.lg)
    }

    private var productHeroImage: some View {
        ZStack {
            if let urlString = product.imageURL, let url = URL(string: urlString) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let img):
                        img.resizable().scaledToFill()
                    default:
                        heroPlaceholder
                    }
                }
            } else {
                heroPlaceholder
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var heroPlaceholder: some View {
        ZStack {
            LinearGradient(
                colors: [
                    DSColors.secondary(theme: colorScheme),
                    DSColors.accent(theme: colorScheme)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            Image(systemName: product.placeholderIcon)
                .font(.system(size: 72))
                .foregroundStyle(.white.opacity(0.6))
        }
    }

    private var heroGradient: some View {
        LinearGradient(
            colors: [.clear, .black.opacity(0.85)],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    @ViewBuilder
    private var outOfStockOverlay: some View {
        if product.isOutOfStock {
            Color.black.opacity(0.6)
                .overlay {
                    Text("Out of stock")
                        .font(DSTypography.subheadline)
                        .foregroundStyle(.white)
                }
        }
    }

    private var priceText: String {
        if unitPrice != product.price {
            return "\(product.priceFormatted) → \(formatPrice(unitPrice))"
        }
        return product.priceFormatted
    }

    private func formatPrice(_ value: Decimal) -> String {
        let f = NumberFormatter()
        f.numberStyle = .currency
        f.currencyCode = "USD"
        return f.string(from: value as NSDecimalNumber) ?? "$\(value)"
    }

    // MARK: - Info

    private var infoSection: some View {
        VStack(alignment: .leading, spacing: DSSpacing.sm) {
            Text(String(localized: String.LocalizationValue(product.descriptionKey)))
                .font(DSTypography.body)
                .foregroundStyle(DSColors.textSecondary(theme: colorScheme))
                .lineSpacing(4)
        }
    }

    // MARK: - Size

    private var sizeSection: some View {
        productCustomizationSection(
            title: "Size",
            icon: "cup.and.saucer.fill"
        ) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: DSSpacing.sm) {
                    ForEach(CustomizationOptions.sizes, id: \.id) { size in
                        optionChip(
                            title: String(localized: String.LocalizationValue(size.nameKey)),
                            subtitle: size.priceModifier > 0 ? "+\(formatPrice(size.priceModifier))" : nil,
                            isSelected: selectedSize == size.id
                        ) {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                selectedSize = size.id
                            }
                        }
                    }
                }
                .padding(.horizontal, 2)
            }
        }
    }

    private var milkSection: some View {
        productCustomizationSection(
            title: "Milk",
            icon: "drop.fill"
        ) {
            FlowLayout(spacing: DSSpacing.sm) {
                ForEach(CustomizationOptions.milkOptions, id: \.id) { milk in
                    optionChip(
                        title: String(localized: String.LocalizationValue(milk.nameKey)),
                        subtitle: milk.priceModifier > 0 ? "+\(formatPrice(milk.priceModifier))" : nil,
                        isSelected: selectedMilk == milk.id
                    ) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                            selectedMilk = milk.id
                        }
                    }
                }
            }
        }
    }

    private var addOnsSection: some View {
        productCustomizationSection(
            title: "Add-ons",
            icon: "plus.circle.fill"
        ) {
            FlowLayout(spacing: DSSpacing.sm) {
                ForEach(CustomizationOptions.addOns, id: \.id) { addOn in
                    optionChip(
                        title: String(localized: String.LocalizationValue(addOn.nameKey)),
                        subtitle: "+\(formatPrice(addOn.price))",
                        isSelected: selectedExtras.contains(addOn.id)
                    ) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                            if selectedExtras.contains(addOn.id) {
                                selectedExtras.remove(addOn.id)
                            } else {
                                selectedExtras.insert(addOn.id)
                            }
                        }
                    }
                }
            }
        }
    }

    private func productCustomizationSection<Content: View>(
        title: String,
        icon: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: DSSpacing.md) {
            HStack(spacing: DSSpacing.sm) {
                Image(systemName: icon)
                    .font(.system(size: 14))
                    .foregroundStyle(DSColors.secondary(theme: colorScheme))
                Text(title)
                    .font(DSTypography.title)
                    .foregroundStyle(DSColors.textPrimary(theme: colorScheme))
            }

            content()
        }
        .padding(DSSpacing.lg)
        .background(DSColors.surface(theme: colorScheme))
        .clipShape(RoundedRectangle(cornerRadius: DSCornerRadius.large))
    }

    private func optionChip(
        title: String,
        subtitle: String?,
        isSelected: Bool,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(DSTypography.caption)
                    .fontWeight(.medium)
                if let s = subtitle {
                    Text(s)
                        .font(.caption2)
                        .foregroundStyle(isSelected ? DSColors.secondary(theme: colorScheme).opacity(0.9) : DSColors.textSecondary(theme: colorScheme))
                }
            }
            .padding(.horizontal, DSSpacing.md)
            .padding(.vertical, DSSpacing.sm)
            .background(
                isSelected
                    ? DSColors.secondary(theme: colorScheme).opacity(0.2)
                    : DSColors.surfaceVariant(theme: colorScheme)
            )
            .foregroundStyle(isSelected ? DSColors.secondary(theme: colorScheme) : DSColors.textPrimary(theme: colorScheme))
            .clipShape(RoundedRectangle(cornerRadius: DSCornerRadius.medium))
        }
        .buttonStyle(ScaleButtonStyle())
    }

    // MARK: - Notes

    private var notesSection: some View {
        VStack(alignment: .leading, spacing: DSSpacing.sm) {
            HStack(spacing: DSSpacing.sm) {
                Image(systemName: "text.alignleft")
                    .font(.system(size: 14))
                    .foregroundStyle(DSColors.secondary(theme: colorScheme))
                Text("Special instructions")
                    .font(DSTypography.title)
                    .foregroundStyle(DSColors.textPrimary(theme: colorScheme))
            }

            DSInput(
                placeholder: "No ice, extra hot...",
                text: $notes,
                icon: nil
            )
        }
    }

    // MARK: - Quantity

    private var quantitySection: some View {
        HStack {
            Text("Quantity")
                .font(DSTypography.title)
                .foregroundStyle(DSColors.textPrimary(theme: colorScheme))

            Spacer()

            HStack(spacing: DSSpacing.lg) {
                Button {
                    if quantity > 1 {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            quantity -= 1
                        }
                    }
                } label: {
                    Image(systemName: "minus.circle.fill")
                        .font(.title)
                        .foregroundStyle(quantity > 1 ? DSColors.secondary(theme: colorScheme) : DSColors.textTertiary(theme: colorScheme))
                }
                .buttonStyle(ScaleButtonStyle())
                .disabled(quantity <= 1)

                Text("\(quantity)")
                    .font(.system(size: 20, weight: .semibold))
                    .frame(minWidth: 28)
                    .foregroundStyle(DSColors.textPrimary(theme: colorScheme))

                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        quantity += 1
                    }
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title)
                        .foregroundStyle(DSColors.secondary(theme: colorScheme))
                }
                .buttonStyle(ScaleButtonStyle())
            }
        }
        .padding(DSSpacing.lg)
        .background(DSColors.surface(theme: colorScheme))
        .clipShape(RoundedRectangle(cornerRadius: DSCornerRadius.large))
    }

    // MARK: - Sticky Add to Cart

    private var stickyAddToCartBar: some View {
        VStack(spacing: 0) {
            Divider()
                .background(DSColors.divider(theme: colorScheme))

            HStack(spacing: DSSpacing.lg) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Total")
                        .font(DSTypography.caption)
                        .foregroundStyle(DSColors.textSecondary(theme: colorScheme))
                    Text(formatPrice(totalPrice))
                        .font(DSTypography.subheadline)
                        .foregroundStyle(DSColors.textPrimary(theme: colorScheme))
                }

                Spacer()

                Button {
                    addToCart()
                } label: {
                    HStack(spacing: DSSpacing.sm) {
                        if addedToCart {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.title3)
                            Text("Added")
                                .font(DSTypography.title)
                        } else {
                            Image(systemName: "cart.badge.plus")
                                .font(.title3)
                            Text("Add to Cart")
                                .font(DSTypography.title)
                        }
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(addedToCart ? DSColors.success(theme: colorScheme) : DSColors.primary(theme: colorScheme))
                    .clipShape(RoundedRectangle(cornerRadius: DSCornerRadius.medium))
                }
                .buttonStyle(ScaleButtonStyle())
                .disabled(product.isOutOfStock || addedToCart)
            }
            .padding(.horizontal, DSSpacing.xl)
            .padding(.vertical, DSSpacing.md)
            .background(DSColors.surface(theme: colorScheme))
        }
    }

    private func addToCart() {
        guard !addedToCart else { return }
        if let id = replaceItemId {
            cartManager.remove(id)
        }
        let c = customization.isEmpty ? nil : customization
        cartManager.add(product, quantity: quantity, customization: c)
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
            addedToCart = true
        }
        cartManager.isCartPresented = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation { addedToCart = false }
        }
    }
}

// MARK: - Flow Layout

struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = arrange(proposal: proposal, subviews: subviews)
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = arrange(proposal: proposal, subviews: subviews)
        for (index, pos) in result.positions.enumerated() {
            subviews[index].place(at: CGPoint(x: bounds.minX + pos.x, y: bounds.minY + pos.y), proposal: .unspecified)
        }
    }

    private func arrange(proposal: ProposedViewSize, subviews: Subviews) -> (size: CGSize, positions: [CGPoint]) {
        let width = proposal.width ?? .infinity
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0
        var positions: [CGPoint] = []

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > width && x > 0 {
                x = 0
                y += rowHeight + spacing
                rowHeight = 0
            }
            positions.append(CGPoint(x: x, y: y))
            rowHeight = max(rowHeight, size.height)
            x += size.width + spacing
        }

        let totalHeight = y + rowHeight
        return (CGSize(width: width, height: totalHeight), positions)
    }
}
