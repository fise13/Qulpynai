//
//  Location.swift
//  Qulpynai
//
//  Domain model — Store location
//

import Foundation

struct Location: Identifiable, Hashable {
    let id: String
    let name: String
    let address: String
    let latitude: Double?
    let longitude: Double?
    let isOpen: Bool

    func hash(into hasher: inout Hasher) { hasher.combine(id) }
    static func == (lhs: Location, rhs: Location) -> Bool { lhs.id == rhs.id }
}
