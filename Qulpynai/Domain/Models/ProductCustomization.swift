//
//  ProductCustomization.swift
//  Qulpynai
//
//  Starbucks-style customization — size, milk, extras, notes
//

import Foundation

/// User-selected customization for a product
struct ProductCustomization: Hashable, Codable {
    var size: String?
    var milk: String?
    var extras: [String] = []
    var notes: String = ""

    var isEmpty: Bool {
        size == nil && milk == nil && extras.isEmpty && notes.isEmpty
    }

    /// Human-readable summary for cart/order
    var summary: String {
        var parts: [String] = []
        if let s = size, !s.isEmpty { parts.append(s) }
        if let m = milk, !m.isEmpty { parts.append(m) }
        if !extras.isEmpty { parts.append(extras.joined(separator: ", ")) }
        if !notes.isEmpty { parts.append("Note: \(notes)") }
        return parts.joined(separator: " · ")
    }
}

/// Available customization options (prices in addition to base)
enum CustomizationOptions {
    static let sizes: [(id: String, nameKey: String, priceModifier: Decimal)] = [
        ("tall", "size_tall", 0),
        ("grande", "size_grande", 0.75),
        ("venti", "size_venti", 1.50)
    ]

    static let milkOptions: [(id: String, nameKey: String, priceModifier: Decimal)] = [
        ("whole", "milk_whole", 0),
        ("oat", "milk_oat", 0.50),
        ("almond", "milk_almond", 0.50),
        ("soy", "milk_soy", 0.50),
        ("skim", "milk_skim", 0)
    ]

    static let addOns: [(id: String, nameKey: String, price: Decimal)] = [
        ("extra_shot", "addon_extra_shot", 0.75),
        ("vanilla", "addon_vanilla", 0.50),
        ("caramel", "addon_caramel", 0.50),
        ("hazelnut", "addon_hazelnut", 0.50),
        ("oat_topping", "addon_oat_topping", 0.25)
    ]

    static func priceModifier(size: String?, milk: String?, extras: [String]) -> Decimal {
        var total: Decimal = 0
        if let s = size {
            total += sizes.first { $0.id == s }?.priceModifier ?? 0
        }
        if let m = milk {
            total += milkOptions.first { $0.id == m }?.priceModifier ?? 0
        }
        for ext in extras {
            total += addOns.first { $0.id == ext }?.price ?? 0
        }
        return total
    }
}
