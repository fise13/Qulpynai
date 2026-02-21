//
//  SettingsView.swift
//  Qulpynai
//
//  Настройки — dark card design
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("prefNotifications") private var notificationsEnabled = true
    @AppStorage("prefOrderUpdates") private var orderUpdates = true
    @AppStorage("prefPromos") private var promos = false
    @AppStorage("prefDarkMode") private var darkModeAuto = true
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DSSpacing.xl) {
                sectionHeader("Тестировщик / Админ")

                settingsCard {
                    NavigationLink {
                        AdminDashboardView()
                    } label: {
                        HStack(spacing: DSSpacing.md) {
                            Image(systemName: "wrench.and.screwdriver.fill")
                                .font(.title3)
                                .foregroundStyle(DSColors.secondary(theme: colorScheme))
                                .frame(width: 24, alignment: .center)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Панель администратора")
                                    .font(DSTypography.body)
                                    .foregroundStyle(DSColors.textPrimary(theme: colorScheme))
                                Text("Меню, каталог, главная, адреса")
                                    .font(DSTypography.caption)
                                    .foregroundStyle(DSColors.textSecondary(theme: colorScheme))
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundStyle(DSColors.textTertiary(theme: colorScheme))
                        }
                        .padding(DSSpacing.md)
                    }
                    .buttonStyle(.plain)
                }

                sectionHeader("Уведомления")

                settingsCard {
                    settingsRow(icon: "bell.fill", title: "Push-уведомления", subtitle: "О статусе заказов") {
                        Toggle("", isOn: $notificationsEnabled)
                            .labelsHidden()
                            .tint(DSColors.secondary(theme: colorScheme))
                    }
                    Divider().background(DSColors.divider(theme: colorScheme)).padding(.leading, 48)

                    settingsRow(icon: "bag.fill", title: "Обновления заказа", subtitle: nil) {
                        Toggle("", isOn: $orderUpdates)
                            .labelsHidden()
                            .tint(DSColors.secondary(theme: colorScheme))
                    }
                    Divider().background(DSColors.divider(theme: colorScheme)).padding(.leading, 48)

                    settingsRow(icon: "tag.fill", title: "Акции и промо", subtitle: nil) {
                        Toggle("", isOn: $promos)
                            .labelsHidden()
                            .tint(DSColors.secondary(theme: colorScheme))
                    }
                }

                sectionHeader("Внешний вид")

                settingsCard {
                    settingsRow(icon: "moon.fill", title: "Тёмная тема", subtitle: "Автоматически") {
                        Toggle("", isOn: $darkModeAuto)
                            .labelsHidden()
                            .tint(DSColors.secondary(theme: colorScheme))
                    }
                }

                sectionHeader("О приложении")

                settingsCard {
                    HStack {
                        Image(systemName: "info.circle.fill")
                            .font(.title3)
                            .foregroundStyle(DSColors.secondary(theme: colorScheme))
                        Text("Версия")
                            .font(DSTypography.body)
                            .foregroundStyle(DSColors.textPrimary(theme: colorScheme))
                        Spacer()
                        Text("1.0.0")
                            .font(DSTypography.bodySmall)
                            .foregroundStyle(DSColors.textSecondary(theme: colorScheme))
                    }
                    .padding(DSSpacing.md)
                }
            }
            .padding(DSSpacing.xl)
        }
        .background(DSColors.background(theme: colorScheme))
        .navigationTitle("Настройки")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(DSTypography.subheadline)
            .foregroundStyle(DSColors.textPrimary(theme: colorScheme))
            .padding(.bottom, DSSpacing.xs)
    }

    private func settingsCard<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        content()
            .background(DSColors.surface(theme: colorScheme))
            .clipShape(RoundedRectangle(cornerRadius: DSCornerRadius.large))
    }

    private func settingsRow<Content: View>(
        icon: String,
        title: String,
        subtitle: String?,
        @ViewBuilder trailing: () -> Content
    ) -> some View {
        HStack(spacing: DSSpacing.md) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(DSColors.secondary(theme: colorScheme))
                .frame(width: 24, alignment: .center)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(DSTypography.body)
                    .foregroundStyle(DSColors.textPrimary(theme: colorScheme))
                if let subtitle {
                    Text(subtitle)
                        .font(DSTypography.caption)
                        .foregroundStyle(DSColors.textSecondary(theme: colorScheme))
                }
            }

            Spacer()
            trailing()
        }
        .padding(DSSpacing.md)
    }
}
