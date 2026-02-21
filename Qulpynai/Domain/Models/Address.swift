//
//  Address.swift
//  Qulpynai
//
//  Domain model — Delivery / billing address
//

import Foundation

struct Address: Identifiable, Hashable {
    let id: String
    var line1: String
    var line2: String?
    var city: String
    var state: String?
    var postalCode: String
    var country: String

    var fullAddress: String {
        var lines = [line1]
        if let l2 = line2, !l2.isEmpty { lines.append(l2) }
        lines.append("\(city)\(state.map { ", \($0)" } ?? "") \(postalCode)")
        lines.append(country)
        return lines.joined(separator: ", ")
    }

    func hash(into hasher: inout Hasher) { hasher.combine(id) }
    static func == (lhs: Address, rhs: Address) -> Bool { lhs.id == rhs.id }
}
