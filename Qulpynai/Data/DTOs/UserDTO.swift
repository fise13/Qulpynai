//
//  UserDTO.swift
//  Qulpynai
//

import Foundation

struct UserDTO: Codable {
    let id: String
    let email: String
    let name: String?

    func toDomain() -> User {
        User(id: id, email: email, name: name)
    }
}
