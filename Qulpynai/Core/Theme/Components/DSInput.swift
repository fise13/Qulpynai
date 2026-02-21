//
//  DSInput.swift
//  Qulpynai
//
//  Design system input field
//

import SwiftUI

struct DSInput: View {
    let placeholder: LocalizedStringKey
    @Binding var text: String
    var isSecure: Bool = false
    var icon: String? = nil
    var errorMessage: String? = nil

    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.xs) {
            HStack(spacing: DSSpacing.sm) {
                if let icon = icon {
                    Image(systemName: icon)
                        .foregroundStyle(DSColors.textTertiary(theme: colorScheme))
                }
                if isSecure {
                    SecureField(placeholder, text: $text)
                        .textFieldStyle(DSInputTextFieldStyle(colorScheme: colorScheme))
                } else {
                    TextField(placeholder, text: $text)
                        .textFieldStyle(DSInputTextFieldStyle(colorScheme: colorScheme))
                }
            }
            .padding(DSSpacing.md)
            .background(DSColors.surfaceVariant(theme: colorScheme))
            .clipShape(RoundedRectangle(cornerRadius: DSCornerRadius.medium))
            .overlay(
                RoundedRectangle(cornerRadius: DSCornerRadius.medium)
                    .stroke(errorMessage != nil ? DSColors.error(theme: colorScheme) : Color.clear, lineWidth: 1)
            )

            if let error = errorMessage {
                Text(error)
                    .font(DSTypography.caption)
                    .foregroundStyle(DSColors.error(theme: colorScheme))
            }
        }
    }
}

struct DSInputTextFieldStyle: TextFieldStyle {
    let colorScheme: ColorScheme

    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .font(DSTypography.body)
            .foregroundStyle(DSColors.textPrimary(theme: colorScheme))
    }
}
