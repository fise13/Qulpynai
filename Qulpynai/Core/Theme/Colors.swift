//
//  Colors.swift
//  Qulpynai
//
//  Design system color tokens — bakery/coffee warm minimal palette
//

import SwiftUI

enum DSColors {
    // MARK: - Brand

    static let primary = Color(hex: "2C1810")
    static let primaryLight = Color(hex: "E8D5C4")

    static let secondary = Color(hex: "8B6914")
    static let secondaryLight = Color(hex: "D4A84B")

    static let accent = Color(hex: "C4A77D")
    static let accentLight = Color(hex: "A68B5B")

    // MARK: - Background & Surface

    static let background = Color(hex: "FFFBF7")
    static let backgroundDark = Color(hex: "1A1512")

    static let surface = Color(hex: "FFFFFF")
    static let surfaceDark = Color(hex: "2C2420")

    static let surfaceVariant = Color(hex: "F5EFE8")
    static let surfaceVariantDark = Color(hex: "3D342E")

    // MARK: - Text

    static let textPrimary = Color(hex: "1A1512")
    static let textPrimaryLight = Color(hex: "FFFBF7")

    static let textSecondary = Color(hex: "6B5B52")
    static let textSecondaryLight = Color(hex: "B8A99A")

    static let textTertiary = Color(hex: "9E8F84")
    static let textTertiaryLight = Color(hex: "7A6F65")

    // MARK: - Semantic

    static let error = Color(hex: "C62828")
    static let errorLight = Color(hex: "EF5350")

    static let success = Color(hex: "2E7D32")
    static let successLight = Color(hex: "66BB6A")

    static let divider = Color(hex: "E5DFD8")
    static let dividerDark = Color(hex: "4A4039")
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
