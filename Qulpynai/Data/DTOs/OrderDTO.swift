//
//  OrderDTO.swift
//  Qulpynai
//

import Foundation

struct OrderDTO: Codable {
    let id: String
    let orderNumber: String
    let date: Date
    let status: String
    let items: [CartItemDTO]
    let total: Decimal
    let userId: String?

    func toDomain() -> Order {
        Order(
            id: id,
            orderNumber: orderNumber,
            date: date,
            status: Order.OrderStatus(rawValue: status) ?? .pending,
            items: items.map { $0.toDomain() },
            total: total,
            userId: userId
        )
    }
}

struct CartItemDTO: Codable {
    let id: String
    let product: ProductDTO
    let quantity: Int
    let customizationDTO: ProductCustomizationDTO?

    func toDomain() -> CartItem {
        CartItem(
            id: id,
            product: product.toDomain(),
            quantity: quantity,
            customization: customizationDTO?.toDomain()
        )
    }

    init(id: String, product: ProductDTO, quantity: Int, customizationDTO: ProductCustomizationDTO? = nil) {
        self.id = id
        self.product = product
        self.quantity = quantity
        self.customizationDTO = customizationDTO
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(String.self, forKey: .id)
        product = try c.decode(ProductDTO.self, forKey: .product)
        quantity = try c.decode(Int.self, forKey: .quantity)
        customizationDTO = try c.decodeIfPresent(ProductCustomizationDTO.self, forKey: .customizationDTO)
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(id, forKey: .id)
        try c.encode(product, forKey: .product)
        try c.encode(quantity, forKey: .quantity)
        try c.encodeIfPresent(customizationDTO, forKey: .customizationDTO)
    }

    enum CodingKeys: String, CodingKey {
        case id, product, quantity
        case customizationDTO = "customization"
    }
}

struct ProductCustomizationDTO: Codable {
    let size: String?
    let milk: String?
    let extras: [String]?
    let notes: String?

    func toDomain() -> ProductCustomization {
        ProductCustomization(
            size: size,
            milk: milk,
            extras: extras ?? [],
            notes: notes ?? ""
        )
    }

    init(from c: ProductCustomization) {
        self.size = c.size
        self.milk = c.milk
        self.extras = c.extras.isEmpty ? nil : c.extras
        self.notes = c.notes.isEmpty ? nil : c.notes
    }
}
