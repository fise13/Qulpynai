//
//  AdminStore.swift
//  Qulpynai
//
//  Admin data store — products, categories, locations, promotions, home content
//

import Foundation
import UIKit

@Observable
final class AdminStore {
    var useAdminData: Bool {
        didSet { save() }
    }
    var products: [AdminProduct] { didSet { save() } }
    var categories: [AdminCategory] { didSet { save() } }
    var locations: [AdminLocation] { didSet { save() } }
    var promotions: [AdminPromotion] { didSet { save() } }
    var featuredProductIds: [String] { didSet { save() } }
    var promoBanner: AdminPromoBanner { didSet { save() } }

    static let imagesDirectoryName = "AdminProductImages"

    init() {
        let initialProducts: [AdminProduct]
        if let data = UserDefaults.standard.data(forKey: Self.productsKey),
           let decoded = try? JSONDecoder().decode([AdminProduct].self, from: data) {
            initialProducts = decoded
        } else {
            initialProducts = MockDataDTO.allProducts.map { AdminProduct.from($0.toDomain()) }
        }
        products = initialProducts

        if let data = UserDefaults.standard.data(forKey: Self.categoriesKey),
           let decoded = try? JSONDecoder().decode([AdminCategory].self, from: data) {
            categories = decoded
        } else {
            categories = MockDataDTO.categories.map { cat in
                AdminCategory(id: cat.id, name: cat.name, nameKey: cat.nameKey ?? "category_\(cat.id)")
            }
        }

        if let data = UserDefaults.standard.data(forKey: Self.locationsKey),
           let decoded = try? JSONDecoder().decode([AdminLocation].self, from: data) {
            locations = decoded
        } else {
            locations = [
                AdminLocation(id: "1", name: "Downtown", address: "123 Main St", isOpen: true),
                AdminLocation(id: "2", name: "Mall", address: "456 Mall Dr", isOpen: true)
            ]
        }

        if let data = UserDefaults.standard.data(forKey: Self.promotionsKey),
           let decoded = try? JSONDecoder().decode([AdminPromotion].self, from: data) {
            promotions = decoded
        } else {
            promotions = [
                AdminPromotion(id: "p1", code: "WELCOME10", typeRaw: "percent", value: 10, minOrderAmount: 15, expiresAt: nil),
                AdminPromotion(id: "p2", code: "WELCOME20", typeRaw: "percent", value: 20, minOrderAmount: 0, expiresAt: nil)
            ]
        }

        if let ids = UserDefaults.standard.stringArray(forKey: Self.featuredKey) {
            featuredProductIds = ids
        } else {
            featuredProductIds = initialProducts.prefix(4).map(\.id)
        }

        if let data = UserDefaults.standard.data(forKey: Self.promoBannerKey),
           let decoded = try? JSONDecoder().decode(AdminPromoBanner.self, from: data) {
            promoBanner = decoded
        } else {
            promoBanner = AdminPromoBanner(
                title: "20% на первый заказ",
                subtitle: "Используйте код WELCOME20 при оформлении",
                code: "WELCOME20"
            )
        }

        useAdminData = UserDefaults.standard.bool(forKey: Self.useAdminDataKey)
    }

    // MARK: - Domain conversions

    var domainProducts: [Product] { products.map { $0.toProduct() } }
    var domainCategories: [Category] { categories.map { $0.toCategory() } }
    var domainLocations: [Location] { locations.map { $0.toLocation() } }
    var domainPromotions: [Promotion] { promotions.map { $0.toPromotion() } }
    var featuredProducts: [Product] { featuredProductIds.compactMap { id in products.first(where: { $0.id == id })?.toProduct() } }

    func promotion(for code: String) -> Promotion? {
        promotions.first { $0.code.uppercased() == code.uppercased() }?.toPromotion()
    }

    // MARK: - CRUD

    func addProduct(_ p: AdminProduct) {
        products.append(p)
    }

    func updateProduct(_ p: AdminProduct) {
        if let i = products.firstIndex(where: { $0.id == p.id }) {
            products[i] = p
        }
    }

    func deleteProduct(id: String) {
        products.removeAll { $0.id == id }
        featuredProductIds.removeAll { $0 == id }
        deleteProductImage(id: id)
    }

    func addCategory(_ c: AdminCategory) {
        categories.append(c)
    }

    func updateCategory(_ c: AdminCategory) {
        if let i = categories.firstIndex(where: { $0.id == c.id }) {
            categories[i] = c
        }
    }

    func deleteCategory(id: String) {
        categories.removeAll { $0.id == id }
    }

    func addLocation(_ l: AdminLocation) {
        locations.append(l)
    }

    func updateLocation(_ l: AdminLocation) {
        if let i = locations.firstIndex(where: { $0.id == l.id }) {
            locations[i] = l
        }
    }

    func deleteLocation(id: String) {
        locations.removeAll { $0.id == id }
    }

    func addPromotion(_ p: AdminPromotion) {
        promotions.append(p)
    }

    func updatePromotion(_ p: AdminPromotion) {
        if let i = promotions.firstIndex(where: { $0.id == p.id }) {
            promotions[i] = p
        }
    }

    func deletePromotion(id: String) {
        promotions.removeAll { $0.id == id }
    }

    func setFeatured(ids: [String]) {
        featuredProductIds = ids
    }

    func updatePromoBanner(title: String, subtitle: String, code: String) {
        promoBanner = AdminPromoBanner(title: title, subtitle: subtitle, code: code)
    }

    // MARK: - Images

    func saveProductImage(id: String, image: UIImage) -> String? {
        guard let data = image.jpegData(compressionQuality: 0.8) else { return nil }
        let dir = Self.imagesDirectory
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        let path = dir.appendingPathComponent("\(id).jpg").path
        try? data.write(to: URL(fileURLWithPath: path))
        return path
    }

    func deleteProductImage(id: String) {
        let url = Self.imagesDirectory.appendingPathComponent("\(id).jpg")
        try? FileManager.default.removeItem(at: url)
    }

    private static var imagesDirectory: URL {
        let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return docs.appendingPathComponent(imagesDirectoryName, isDirectory: true)
    }

    // MARK: - Persist

    private func save() {
        if let data = try? JSONEncoder().encode(products) {
            UserDefaults.standard.set(data, forKey: Self.productsKey)
        }
        if let data = try? JSONEncoder().encode(categories) {
            UserDefaults.standard.set(data, forKey: Self.categoriesKey)
        }
        if let data = try? JSONEncoder().encode(locations) {
            UserDefaults.standard.set(data, forKey: Self.locationsKey)
        }
        if let data = try? JSONEncoder().encode(promotions) {
            UserDefaults.standard.set(data, forKey: Self.promotionsKey)
        }
        UserDefaults.standard.set(featuredProductIds, forKey: Self.featuredKey)
        if let data = try? JSONEncoder().encode(promoBanner) {
            UserDefaults.standard.set(data, forKey: Self.promoBannerKey)
        }
        UserDefaults.standard.set(useAdminData, forKey: Self.useAdminDataKey)
    }

    private static let productsKey = "qulpynai_admin_products"
    private static let categoriesKey = "qulpynai_admin_categories"
    private static let locationsKey = "qulpynai_admin_locations"
    private static let promotionsKey = "qulpynai_admin_promotions"
    private static let featuredKey = "qulpynai_admin_featured"
    private static let promoBannerKey = "qulpynai_admin_promo_banner"
    private static let useAdminDataKey = "qulpynai_admin_use_data"
}
