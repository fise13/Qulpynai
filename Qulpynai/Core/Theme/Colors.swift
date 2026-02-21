//
//  Colors.swift
//  Qulpynai
//
//  Design system — dark artisan bakery palette
//

import SwiftUI

enum DSColors {
    // MARK: - Brand (warm terracotta / amber)

    static let primary = Color(hex: "1C1917")
    static let primaryLight = Color(hex: "FEF3C7")

    static let secondary = Color(hex: "D97706")
    static let secondaryLight = Color(hex: "FCD34D")

    static let accent = Color(hex: "B45309")
    static let accentLight = Color(hex: "F59E0B")

    // MARK: - Background & Surface

    static let background = Color(hex: "FFFBEB")
    static let backgroundDark = Color(hex: "0F0D0B")

    static let surface = Color(hex: "FFFFFF")
    static let surfaceDark = Color(hex: "292524")

    static let surfaceVariant = Color(hex: "FEF3C7")
    static let surfaceVariantDark = Color(hex: "44403C")

    // MARK: - Text

    static let textPrimary = Color(hex: "1C1917")
    static let textPrimaryLight = Color(hex: "FAFAF9")

    static let textSecondary = Color(hex: "57534E")
    static let textSecondaryLight = Color(hex: "A8A29E")

    static let textTertiary = Color(hex: "78716C")
    static let textTertiaryLight = Color(hex: "78716C")

    // MARK: - Semantic

    static let error = Color(hex: "DC2626")
    static let errorLight = Color(hex: "FCA5A5")

    static let success = Color(hex: "059669")
    static let successLight = Color(hex: "34D399")

    static let divider = Color(hex: "E7E5E4")
    static let dividerDark = Color(hex: "44403C")
}

// MARK: - Adaptive Colors

extension DSColors {
    static func primary(theme: ColorScheme) -> Color {
        theme == .dark ? primaryLight : primary
    }

    static func secondary(theme: ColorScheme) -> Color {
        theme == .dark ? secondaryLight : secondary
    }

    static func accent(theme: ColorScheme) -> Color {
        theme == .dark ? accentLight : accent
    }

    static func background(theme: ColorScheme) -> Color {
        theme == .dark ? backgroundDark : background
    }

    static func surface(theme: ColorScheme) -> Color {
        theme == .dark ? surfaceDark : surface
    }

    static func surfaceVariant(theme: ColorScheme) -> Color {
        theme == .dark ? surfaceVariantDark : surfaceVariant
    }

    static func textPrimary(theme: ColorScheme) -> Color {
        theme == .dark ? textPrimaryLight : textPrimary
    }

    static func textSecondary(theme: ColorScheme) -> Color {
        theme == .dark ? textSecondaryLight : textSecondary
    }

    static func textTertiary(theme: ColorScheme) -> Color {
        theme == .dark ? textTertiaryLight : textTertiary
    }

    static func error(theme: ColorScheme) -> Color {
        theme == .dark ? errorLight : error
    }

    static func success(theme: ColorScheme) -> Color {
        theme == .dark ? successLight : success
    }

    static func divider(theme: ColorScheme) -> Color {
        theme == .dark ? dividerDark : divider
    }
}

// MARK: - Hex Color Extension

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
