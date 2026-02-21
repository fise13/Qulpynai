//
//  CategoryDTO.swift
//  Qulpynai
//

import Foundation

struct CategoryDTO: Codable {
    let id: String
    let name: String
    let nameKey: String?

    func toDomain() -> Category {
        Category(id: id, name: name, nameKey: nameKey ?? "category_\(id)")
    }
}
