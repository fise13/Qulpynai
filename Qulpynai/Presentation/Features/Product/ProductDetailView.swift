//
//  ProductDetailView.swift
//  Qulpynai
//
//  Starbucks-style product detail — customize size, milk, extras, add to cart
//

import SwiftUI

struct ProductDetailView: View {
    let product: Product
    /// When editing from cart, remove this item before adding updated one
    var replaceItemId: String? = nil
    @Environment(CartManager.self) private var cartManager
    @State private var quantity: Int
    @State private var addedToCart = false
    @State private var imageScale: CGFloat = 0.95

    // Customization
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
        ScrollView {
            VStack(alignment: .leading, spacing: DSSpacing.lg) {
                productImage

                VStack(alignment: .leading, spacing: DSSpacing.md) {
                    Text(String(localized: String.LocalizationValue(product.nameKey)))
                        .font(DSTypography.headline)
                        .foregroundStyle(DSColors.textPrimary(theme: colorScheme))

                    Text(priceText)
                        .font(DSTypography.subheadline)
                        .foregroundStyle(DSColors.secondary(theme: colorScheme))

                    Text(String(localized: String.LocalizationValue(product.descriptionKey)))
                        .font(DSTypography.body)
                        .foregroundStyle(DSColors.textSecondary(theme: colorScheme))
                }

                if isDrink {
                    sizeSection
                    milkSection
                    addOnsSection
                }

                notesSection

                quantitySection

                addToCartButton
            }
            .padding(DSSpacing.xl)
        }
        .background(DSColors.background(theme: colorScheme))
        .navigationTitle(String(localized: String.LocalizationValue(product.nameKey)))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                CartButton()
            }
        }
    }

    private var productImage: some View {
        ZStack {
            RoundedRectangle(cornerRadius: DSCornerRadius.large)
                .fill(DSColors.surfaceVariant(theme: colorScheme))
                .aspectRatio(1, contentMode: .fit)

            Image(systemName: product.placeholderIcon)
                .font(.system(size: 64))
                .foregroundStyle(DSColors.accent(theme: colorScheme))
                .scaleEffect(imageScale)
        }
        .clipShape(RoundedRectangle(cornerRadius: DSCornerRadius.large))
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                imageScale = 1
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

    private var sizeSection: some View {
        customizationSection(title: "Size") {
            ForEach(CustomizationOptions.sizes, id: \.id) { size in
                optionChip(
                    title: String(localized: String.LocalizationValue(size.nameKey)),
                    subtitle: size.priceModifier > 0 ? "+\(formatPrice(size.priceModifier))" : nil,
                    isSelected: selectedSize == size.id
                ) {
                    selectedSize = size.id
                }
            }
        }
    }

    private var milkSection: some View {
        customizationSection(title: "Milk") {
            ForEach(CustomizationOptions.milkOptions, id: \.id) { milk in
                optionChip(
                    title: String(localized: String.LocalizationValue(milk.nameKey)),
                    subtitle: milk.priceModifier > 0 ? "+\(formatPrice(milk.priceModifier))" : nil,
                    isSelected: selectedMilk == milk.id
                ) {
                    selectedMilk = milk.id
                }
            }
        }
    }

    private var addOnsSection: some View {
        customizationSection(title: "Add-ons") {
            ForEach(CustomizationOptions.addOns, id: \.id) { addOn in
                optionChip(
                    title: String(localized: String.LocalizationValue(addOn.nameKey)),
                    subtitle: "+\(formatPrice(addOn.price))",
                    isSelected: selectedExtras.contains(addOn.id)
                ) {
                    if selectedExtras.contains(addOn.id) {
                        selectedExtras.remove(addOn.id)
                    } else {
                        selectedExtras.insert(addOn.id)
                    }
                }
            }
        }
    }

    private var notesSection: some View {
        VStack(alignment: .leading, spacing: DSSpacing.sm) {
            Text("Special instructions")
                .font(DSTypography.subheadline)
                .foregroundStyle(DSColors.textPrimary(theme: colorScheme))
            DSInput(placeholder: "No ice, extra hot...", text: $notes, icon: "text.alignleft")
        }
    }

    private var quantitySection: some View {
        HStack {
            Text("Quantity")
                .font(DSTypography.title)
                .foregroundStyle(DSColors.textPrimary(theme: colorScheme))

            Spacer()

            HStack(spacing: DSSpacing.sm) {
                Button {
                    if quantity > 1 {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            quantity -= 1
                        }
                    }
                } label: {
                    Image(systemName: "minus.circle.fill")
                        .font(.title2)
                        .foregroundStyle(quantity > 1 ? DSColors.primary(theme: colorScheme) : DSColors.textTertiary(theme: colorScheme))
                }
                .buttonStyle(ScaleButtonStyle())
                .disabled(quantity <= 1)

                Text("\(quantity)")
                    .font(DSTypography.title)
                    .frame(minWidth: 24)
                    .foregroundStyle(DSColors.textPrimary(theme: colorScheme))

                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        quantity += 1
                    }
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundStyle(DSColors.primary(theme: colorScheme))
                }
                .buttonStyle(ScaleButtonStyle())
            }
        }
        .padding(DSSpacing.md)
        .background(DSColors.surface(theme: colorScheme))
        .clipShape(RoundedRectangle(cornerRadius: DSCornerRadius.medium))
    }

    private var addToCartButton: some View {
        DSButton(title: LocalizedStringKey(stringLiteral: addToCartTitle), style: addToCartStyle) {
            guard !addedToCart else { return }
            if let id = replaceItemId {
                cartManager.remove(id)
            }
            let c = customization.isEmpty ? nil : customization
            cartManager.add(product, quantity: quantity, customization: c)
            withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                addedToCart = true
            }
            cartManager.isCartPresented = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation { addedToCart = false }
            }
        }
    }

    private var addToCartTitle: String {
        if addedToCart { return "Added" }
        return "Add to Cart · \(formatPrice(totalPrice))"
    }

    private var addToCartStyle: DSButtonStyle {
        addedToCart ? .disabled : .primary
    }

    private func customizationSection<Content: View>(
        title: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: DSSpacing.sm) {
            Text(title)
                .font(DSTypography.subheadline)
                .foregroundStyle(DSColors.textPrimary(theme: colorScheme))

            FlowLayout(spacing: DSSpacing.sm) {
                content()
            }
        }
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
                if let s = subtitle {
                    Text(s)
                        .font(.caption2)
                        .foregroundStyle(DSColors.textSecondary(theme: colorScheme))
                }
            }
            .padding(.horizontal, DSSpacing.md)
            .padding(.vertical, DSSpacing.sm)
            .background(isSelected ? DSColors.secondary(theme: colorScheme).opacity(0.2) : DSColors.surfaceVariant(theme: colorScheme))
            .foregroundStyle(isSelected ? DSColors.secondary(theme: colorScheme) : DSColors.textPrimary(theme: colorScheme))
            .clipShape(RoundedRectangle(cornerRadius: DSCornerRadius.small))
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

/// Simple flow layout for customization chips
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
