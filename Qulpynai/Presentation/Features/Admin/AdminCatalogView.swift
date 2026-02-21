//
//  AdminCatalogView.swift
//  Qulpynai
//
//  Admin — catalog: products and categories
//

import SwiftUI
import PhotosUI

struct AdminCatalogView: View {
    @Environment(AdminStore.self) private var adminStore
    @State private var selectedTab = 0
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(spacing: 0) {
            Picker("", selection: $selectedTab) {
                Text("Товары").tag(0)
                Text("Категории").tag(1)
            }
            .pickerStyle(.segmented)
            .padding(DSSpacing.md)

            if selectedTab == 0 {
                AdminProductsListView()
            } else {
                AdminCategoriesListView()
            }
        }
        .navigationTitle("Каталог")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Products List

struct AdminProductsListView: View {
    @Environment(AdminStore.self) private var adminStore
    @State private var showAdd = false
    @State private var editingProduct: AdminProduct?
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        List {
            ForEach(adminStore.products) { p in
                Button {
                    editingProduct = p
                } label: {
                    AdminProductRow(product: p)
                }
                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                    Button(role: .destructive) {
                        adminStore.deleteProduct(id: p.id)
                    } label: {
                        Label("Удалить", systemImage: "trash")
                    }
                }
            }
        }
        .listStyle(.plain)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showAdd = true
                } label: {
                    Image(systemName: "plus.circle.fill")
                }
            }
        }
        .sheet(isPresented: $showAdd) {
            AdminProductFormView(product: nil) { p in
                adminStore.addProduct(p)
            }
        }
        .sheet(item: $editingProduct) { p in
            AdminProductFormView(product: p) { updated in
                adminStore.updateProduct(updated)
            }
        }
    }
}

struct AdminProductRow: View {
    let product: AdminProduct
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        HStack(spacing: DSSpacing.md) {
            productImage
                .frame(width: 56, height: 56)
                .clipShape(RoundedRectangle(cornerRadius: DSCornerRadius.small))

            VStack(alignment: .leading, spacing: 4) {
                Text(product.name)
                    .font(DSTypography.title)
                    .foregroundStyle(DSColors.textPrimary(theme: colorScheme))
                Text(formatPrice(product.price))
                    .font(DSTypography.caption)
                    .foregroundStyle(DSColors.textSecondary(theme: colorScheme))
            }
            Spacer()
            if product.isOutOfStock {
                Text("Нет в наличии")
                    .font(DSTypography.captionSmall)
                    .foregroundStyle(DSColors.error(theme: colorScheme))
            }
        }
        .padding(.vertical, DSSpacing.sm)
    }

    @ViewBuilder
    private var productImage: some View {
        if let path = product.imagePath, !path.isEmpty, let uiImage = UIImage(contentsOfFile: path) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
        } else {
            Image(systemName: product.placeholderIcon)
                .font(.title2)
                .foregroundStyle(DSColors.accent(theme: colorScheme))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(DSColors.surfaceVariant(theme: colorScheme))
        }
    }

    private func formatPrice(_ value: Decimal) -> String {
        let f = NumberFormatter()
        f.numberStyle = .currency
        f.currencyCode = "USD"
        return f.string(from: value as NSDecimalNumber) ?? "$\(value)"
    }
}

// MARK: - Product Form (with photo)

struct AdminProductFormView: View {
    let product: AdminProduct?
    let onSave: (AdminProduct) -> Void
    @Environment(\.dismiss) private var dismiss
    @Environment(AdminStore.self) private var adminStore
    @Environment(\.colorScheme) private var colorScheme

    @State private var name: String = ""
    @State private var description: String = ""
    @State private var priceText: String = ""
    @State private var categoryId: String = "pastries"
    @State private var placeholderIcon: String = "leaf.fill"
    @State private var isOutOfStock: Bool = false
    @State private var selectedImage: UIImage?
    @State private var selectedItem: PhotosPickerItem?

    private let icons = ["leaf.fill", "cup.and.saucer.fill", "birthday.cake.fill", "fork.knife", "takeoutbag.and.cup.and.straw.fill"]

    var body: some View {
        NavigationStack {
            Form {
                Section("Фото") {
                    PhotosPicker(
                        selection: $selectedItem,
                        matching: .images
                    ) {
                        if let img = selectedImage {
                            Image(uiImage: img)
                                .resizable()
                                .scaledToFill()
                                .frame(height: 120)
                                .clipShape(RoundedRectangle(cornerRadius: DSCornerRadius.medium))
                        } else if let p = product, let path = p.imagePath, let uiImage = UIImage(contentsOfFile: path) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(height: 120)
                                .clipShape(RoundedRectangle(cornerRadius: DSCornerRadius.medium))
                        } else {
                            HStack {
                                Image(systemName: "photo.badge.plus")
                                    .font(.title)
                                Text("Выбрать фото")
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 80)
                            .background(DSColors.surfaceVariant(theme: colorScheme))
                            .clipShape(RoundedRectangle(cornerRadius: DSCornerRadius.medium))
                        }
                    }
                    .onChange(of: selectedItem) { _, newValue in
                        Task {
                            if let data = try? await newValue?.loadTransferable(type: Data.self),
                               let img = UIImage(data: data) {
                                await MainActor.run { selectedImage = img }
                            }
                        }
                    }
                }

                Section("Основное") {
                    TextField("Название", text: $name)
                    TextField("Описание", text: $description)
                    TextField("Цена", text: $priceText)
                        .keyboardType(.decimalPad)
                    Picker("Категория", selection: $categoryId) {
                        ForEach(adminStore.categories) { c in
                            Text(c.name).tag(c.id)
                        }
                    }
                    Picker("Иконка", selection: $placeholderIcon) {
                        ForEach(icons, id: \.self) { icon in
                            Label(icon, systemImage: icon).tag(icon)
                        }
                    }
                    Toggle("Нет в наличии", isOn: $isOutOfStock)
                        .tint(DSColors.secondary(theme: colorScheme))
                }
            }
            .navigationTitle(product == nil ? "Новый товар" : "Редактировать")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отмена") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Сохранить") { save() }
                        .disabled(name.isEmpty || priceText.isEmpty)
                }
            }
            .onAppear {
                if let p = product {
                    name = p.name
                    description = p.description
                    priceText = "\(p.price)"
                    categoryId = p.categoryId
                    placeholderIcon = p.placeholderIcon
                    isOutOfStock = p.isOutOfStock
                }
            }
        }
    }

    private func save() {
        guard let price = Decimal(string: priceText.replacingOccurrences(of: ",", with: ".")) else { return }
        let id = product?.id ?? UUID().uuidString
        var imagePath: String?
        if let img = selectedImage {
            imagePath = adminStore.saveProductImage(id: id, image: img)
        } else if let p = product, let path = p.imagePath {
            imagePath = path
        }
        let ap = AdminProduct(
            id: id,
            name: name,
            nameKey: "product_\(id.replacingOccurrences(of: "-", with: "_"))",
            description: description,
            descriptionKey: "product_\(id.replacingOccurrences(of: "-", with: "_"))_desc",
            price: price,
            categoryId: categoryId,
            imagePath: imagePath,
            placeholderIcon: placeholderIcon,
            isOutOfStock: isOutOfStock
        )
        onSave(ap)
        dismiss()
    }
}

// MARK: - Categories List

struct AdminCategoriesListView: View {
    @Environment(AdminStore.self) private var adminStore
    @State private var showAdd = false
    @State private var editingCategory: AdminCategory?
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        List {
            ForEach(adminStore.categories.filter { $0.id != "all" }) { c in
                Button {
                    editingCategory = c
                } label: {
                    HStack {
                        Text(c.name)
                            .font(DSTypography.body)
                            .foregroundStyle(DSColors.textPrimary(theme: colorScheme))
                        Spacer()
                        Text("\(adminStore.products.filter { $0.categoryId == c.id }.count) товаров")
                            .font(DSTypography.caption)
                            .foregroundStyle(DSColors.textSecondary(theme: colorScheme))
                    }
                }
                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                    Button(role: .destructive) {
                        adminStore.deleteCategory(id: c.id)
                    } label: {
                        Label("Удалить", systemImage: "trash")
                    }
                }
            }
        }
        .listStyle(.plain)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showAdd = true
                } label: {
                    Image(systemName: "plus.circle.fill")
                }
            }
        }
        .sheet(isPresented: $showAdd) {
            AdminCategoryFormView(category: nil) { c in
                adminStore.addCategory(c)
            }
        }
        .sheet(item: $editingCategory) { c in
            AdminCategoryFormView(category: c) { updated in
                adminStore.updateCategory(updated)
            }
        }
    }
}

struct AdminCategoryFormView: View {
    let category: AdminCategory?
    let onSave: (AdminCategory) -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var name: String = ""

    var body: some View {
        NavigationStack {
            Form {
                TextField("Название", text: $name)
            }
            .navigationTitle(category == nil ? "Новая категория" : "Редактировать")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отмена") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Сохранить") {
                        let id = category?.id ?? name.lowercased().replacingOccurrences(of: " ", with: "_")
                        onSave(AdminCategory(id: id, name: name, nameKey: "category_\(id)"))
                        dismiss()
                    }
                    .disabled(name.isEmpty)
                }
            }
            .onAppear {
                name = category?.name ?? ""
            }
        }
    }
}

