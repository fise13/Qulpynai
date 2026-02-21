//
//  MockDataDTO.swift
//  Qulpynai
//
//  Mock DTO data
//

import Foundation

enum MockDataDTO {
    static let categories: [CategoryDTO] = [
        CategoryDTO(id: "all", name: "All", nameKey: "category_all"),
        CategoryDTO(id: "pastries", name: "Pastries", nameKey: "category_pastries"),
        CategoryDTO(id: "drinks", name: "Drinks", nameKey: "category_drinks"),
        CategoryDTO(id: "sandwiches", name: "Sandwiches", nameKey: "category_sandwiches"),
        CategoryDTO(id: "desserts", name: "Desserts", nameKey: "category_desserts")
    ]

    static var allProducts: [ProductDTO] {
        products(for: nil)
    }

    static func products(for categoryId: String?) -> [ProductDTO] {
        let all: [ProductDTO] = [
            ProductDTO(id: "1", name: "Croissant", nameKey: "product_croissant", description: "Fresh butter croissant", descriptionKey: "product_croissant_desc", price: 4.50, categoryId: "pastries", imageURL: nil, placeholderIcon: "leaf.fill"),
            ProductDTO(id: "2", name: "Espresso", nameKey: "product_espresso", description: "Double shot", descriptionKey: "product_espresso_desc", price: 3.50, categoryId: "drinks", imageURL: nil, placeholderIcon: "cup.and.saucer.fill"),
            ProductDTO(id: "3", name: "Cappuccino", nameKey: "product_cappuccino", description: "Espresso with foam", descriptionKey: "product_cappuccino_desc", price: 4.75, categoryId: "drinks", imageURL: nil, placeholderIcon: "cup.and.saucer.fill"),
            ProductDTO(id: "4", name: "Chocolate Cake", nameKey: "product_chocolate_cake", description: "Rich chocolate", descriptionKey: "product_chocolate_cake_desc", price: 6.50, categoryId: "desserts", imageURL: nil, placeholderIcon: "birthday.cake.fill"),
            ProductDTO(id: "5", name: "Avocado Toast", nameKey: "product_avocado_toast", description: "Sourdough with avocado", descriptionKey: "product_avocado_toast_desc", price: 9.00, categoryId: "sandwiches", imageURL: nil, placeholderIcon: "fork.knife"),
            ProductDTO(id: "6", name: "Latte", nameKey: "product_latte", description: "Espresso with milk", descriptionKey: "product_latte_desc", price: 4.75, categoryId: "drinks", imageURL: nil, placeholderIcon: "cup.and.saucer.fill"),
            ProductDTO(id: "7", name: "Almond Croissant", nameKey: "product_almond_croissant", description: "Almond cream", descriptionKey: "product_almond_croissant_desc", price: 5.50, categoryId: "pastries", imageURL: nil, placeholderIcon: "leaf.fill"),
            ProductDTO(id: "8", name: "Cheesecake Slice", nameKey: "product_cheesecake", description: "NY style", descriptionKey: "product_cheesecake_desc", price: 7.00, categoryId: "desserts", imageURL: nil, placeholderIcon: "birthday.cake.fill")
        ]
        guard let id = categoryId, id != "all" else { return all }
        return all.filter { $0.categoryId == id }
    }

    static var orders: [OrderDTO] {
        let prods = allProducts
        return [
            OrderDTO(
                id: "o1",
                orderNumber: "#1234",
                date: Date().addingTimeInterval(-86400 * 2),
                status: "delivered",
                items: [
                    CartItemDTO(id: "ci1", product: prods[0], quantity: 2),
                    CartItemDTO(id: "ci2", product: prods[1], quantity: 1)
                ],
                total: 12.50,
                userId: nil
            ),
            OrderDTO(
                id: "o2",
                orderNumber: "#1235",
                date: Date().addingTimeInterval(-86400 * 5),
                status: "delivered",
                items: [CartItemDTO(id: "ci3", product: prods[3], quantity: 1)],
                total: 6.50,
                userId: nil
            )
        ]
    }
}
