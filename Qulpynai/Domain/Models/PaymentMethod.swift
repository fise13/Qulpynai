//
//  PaymentMethod.swift
//  Qulpynai
//
//  Domain model — PaymentMethod
//

import Foundation

struct PaymentMethod: Identifiable {
    let id: String
    let type: PaymentType
    let lastFour: String

    enum PaymentType {
        case card
        case applePay
    }
}
