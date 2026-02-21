//
//  AuthView.swift
//  Qulpynai
//
//  Login / Register — uses AuthManager
//

import SwiftUI

struct AuthView: View {
    var onDismiss: (() -> Void)? = nil
    @Environment(\.dismiss) private var dismiss
    @Environment(AuthManager.self) private var authManager
    @State private var isLoginMode = true
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var contentOpacity: Double = 0
    @State private var isLoading = false
    @State private var errorMessage: String?

    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: DSSpacing.xl) {
                    VStack(spacing: DSSpacing.sm) {
                        Image(systemName: "cup.and.saucer.fill")
                            .font(.system(size: 48))
                            .foregroundStyle(DSColors.secondary(theme: colorScheme))
                            .symbolEffect(.bounce, value: isLoginMode)

                        Text(isLoginMode ? "Welcome Back" : "Create Account")
                            .font(DSTypography.headline)
                            .foregroundStyle(DSColors.textPrimary(theme: colorScheme))
                    }
                    .padding(.top, DSSpacing.lg)
                    .opacity(contentOpacity)

                    if let error = errorMessage {
                        Text(error)
                            .font(DSTypography.caption)
                            .foregroundStyle(DSColors.error(theme: colorScheme))
                    }

                    VStack(spacing: DSSpacing.md) {
                        if !isLoginMode {
                            DSInput(placeholder: "Name", text: $name, icon: "person")
                        }
                        DSInput(placeholder: "Email", text: $email, icon: "envelope")
                        DSInput(placeholder: "Password", text: $password, isSecure: true, icon: "lock")
                        if !isLoginMode {
                            DSInput(placeholder: "Confirm Password", text: $confirmPassword, isSecure: true, icon: "lock")
                        }
                    }
                    .opacity(contentOpacity)

                    VStack(spacing: DSSpacing.md) {
                        DSButton(title: isLoginMode ? "Log in" : "Sign up", style: isLoading ? .disabled : .primary) {
                            Task { await performAuth() }
                        }
                        .disabled(isLoading)

                        Button {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                isLoginMode.toggle()
                                errorMessage = nil
                            }
                        } label: {
                            Text(isLoginMode ? "Don't have an account? Sign up" : "Already have an account? Log in")
                                .font(DSTypography.bodySmall)
                                .foregroundStyle(DSColors.secondary(theme: colorScheme))
                        }
                    }
                    .opacity(contentOpacity)
                }
            }
            .scrollDismissesKeyboard(.interactively)
            .background(DSColors.background(theme: colorScheme))
            .navigationTitle(isLoginMode ? "Log in" : "Sign up")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        onDismiss?()
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundStyle(DSColors.textTertiary(theme: colorScheme))
                    }
                }
            }
            .onAppear {
                withAnimation(.easeOut(duration: 0.5)) {
                    contentOpacity = 1
                }
            }
        }
    }

    private func performAuth() async {
        guard !email.isEmpty, password.count >= 4 else {
            errorMessage = "Please enter valid email and password"
            return
        }
        if !isLoginMode, password != confirmPassword {
            errorMessage = "Passwords do not match"
            return
        }
        isLoading = true
        errorMessage = nil
        do {
            if isLoginMode {
                try await authManager.login(email: email, password: password)
            } else {
                try await authManager.register(email: email, password: password, name: name.isEmpty ? nil : name)
            }
            await MainActor.run {
                onDismiss?()
                dismiss()
            }
        } catch {
            await MainActor.run {
                errorMessage = error.localizedDescription
            }
        }
        isLoading = false
    }
}
