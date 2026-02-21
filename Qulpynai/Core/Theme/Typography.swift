//
//  Typography.swift
//  Qulpynai
//
//  Design system — serif headlines, crisp body
//

import SwiftUI

enum DSTypography {
    // MARK: - Display & Headlines (serif)

    static let display = Font.system(size: 36, weight: .bold, design: .serif)
    static let headline = Font.system(size: 26, weight: .semibold, design: .serif)
    static let subheadline = Font.system(size: 20, weight: .semibold)
    static let title = Font.system(size: 17, weight: .semibold)

    // MARK: - Body

    static let body = Font.system(size: 16, weight: .regular)
    static let bodySmall = Font.system(size: 14, weight: .regular)

    // MARK: - Caption

    static let caption = Font.system(size: 13, weight: .medium)
    static let captionSmall = Font.system(size: 11, weight: .medium)
}

// MARK: - Text View Modifiers

extension View {
    func dsDisplay() -> some View { font(DSTypography.display) }
    func dsHeadline() -> some View { font(DSTypography.headline) }
    func dsSubheadline() -> some View { font(DSTypography.subheadline) }
    func dsTitle() -> some View { font(DSTypography.title) }
    func dsBody() -> some View { font(DSTypography.body) }
    func dsBodySmall() -> some View { font(DSTypography.bodySmall) }
    func dsCaption() -> some View { font(DSTypography.caption) }
    func dsCaptionSmall() -> some View { font(DSTypography.captionSmall) }
}
