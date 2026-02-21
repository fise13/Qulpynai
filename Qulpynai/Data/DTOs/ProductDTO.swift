//
//  ProductDTO.swift
//  Qulpynai
//

import Foundation

struct ProductDTO: Codable {
    let id: String
    let name: String
    let nameKey: String?
    let description: String
    let descriptionKey: String?
    let price: Decimal
    let categoryId: String
    let imageURL: String?
    let placeholderIcon: String?
    let isOutOfStock: Bool?

    init(id: String, name: String, nameKey: String?, description: String, descriptionKey: String?, price: Decimal, categoryId: String, imageURL: String?, placeholderIcon: String?, isOutOfStock: Bool? = nil) {
        self.id = id
        self.name = name
        self.nameKey = nameKey
        self.description = description
        self.descriptionKey = descriptionKey
        self.price = price
        self.categoryId = categoryId
        self.imageURL = imageURL
        self.placeholderIcon = placeholderIcon
        self.isOutOfStock = isOutOfStock
    }

    init(from product: Product) {
        self.id = product.id
        self.name = product.name
        self.nameKey = product.nameKey
        self.description = product.description
        self.descriptionKey = product.descriptionKey
        self.price = product.price
        self.categoryId = product.categoryId
        self.imageURL = product.imageURL
        self.placeholderIcon = product.placeholderIcon
        self.isOutOfStock = product.isOutOfStock
    }

    func toDomain() -> Product {
        Product(
            id: id,
            name: name,
            nameKey: nameKey ?? "product_\(id)",
            description: description,
            descriptionKey: descriptionKey ?? "product_\(id)_desc",
            price: price,
            categoryId: categoryId,
            imageURL: imageURL,
            placeholderIcon: placeholderIcon ?? "leaf.fill",
            isOutOfStock: isOutOfStock ?? false
        )
    }
}
