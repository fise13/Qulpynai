//
//  AdminModels.swift
//  Qulpynai
//
//  Editable models for admin panel
//

import Foundation

struct AdminProduct: Identifiable, Codable, Hashable {
    var id: String
    var name: String
    var nameKey: String
    var description: String
    var descriptionKey: String
    var price: Decimal
    var categoryId: String
    var imagePath: String?
    var placeholderIcon: String
    var isOutOfStock: Bool

    func toProduct() -> Product {
        let urlString: String?
        if let path = imagePath, !path.isEmpty {
            urlString = "file://\(path)"
        } else {
            urlString = nil
        }
        return Product(
            id: id,
            name: name,
            nameKey: nameKey,
            description: description,
            descriptionKey: descriptionKey,
            price: price,
            categoryId: categoryId,
            imageURL: urlString,
            placeholderIcon: placeholderIcon,
            isOutOfStock: isOutOfStock
        )
    }

    static func from(_ product: Product) -> AdminProduct {
        let path: String?
        if let url = product.imageURL, url.hasPrefix("file://") {
            path = String(url.dropFirst("file://".count))
        } else {
            path = nil
        }
        return AdminProduct(
            id: product.id,
            name: product.name,
            nameKey: product.nameKey,
            description: product.description,
            descriptionKey: product.descriptionKey,
            price: product.price,
            categoryId: product.categoryId,
            imagePath: path,
            placeholderIcon: product.placeholderIcon,
            isOutOfStock: product.isOutOfStock
        )
    }
}

struct AdminCategory: Identifiable, Codable, Hashable {
    var id: String
    var name: String
    var nameKey: String

    func toCategory() -> Category {
        Category(id: id, name: name, nameKey: nameKey)
    }
}

struct AdminLocation: Identifiable, Codable, Hashable {
    var id: String
    var name: String
    var address: String
    var isOpen: Bool

    func toLocation() -> Location {
        Location(id: id, name: name, address: address, latitude: nil, longitude: nil, isOpen: isOpen)
    }
}

struct AdminPromotion: Identifiable, Codable, Hashable {
    var id: String
    var code: String
    var typeRaw: String
    var value: Decimal
    var minOrderAmount: Decimal?
    var expiresAt: Date?

    var type: Promotion.PromotionType {
        get { Promotion.PromotionType(rawValue: typeRaw) ?? .percent }
        set { typeRaw = newValue.rawValue }
    }

    func toPromotion() -> Promotion {
        Promotion(
            id: id,
            code: code,
            type: type,
            value: value,
            minOrderAmount: minOrderAmount,
            expiresAt: expiresAt
        )
    }
}

struct AdminPromoBanner: Codable {
    var title: String
    var subtitle: String
    var code: String
}
