//
//  AdminDashboardView.swift
//  Qulpynai
//
//  Admin panel — dashboard with navigation to sections
//

import SwiftUI

struct AdminDashboardView: View {
    @Environment(AdminStore.self) private var adminStore
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: DSSpacing.xl) {
                    useAdminDataToggle

                    VStack(alignment: .leading, spacing: DSSpacing.sm) {
                        Text("Управление")
                            .font(DSTypography.subheadline)
                            .foregroundStyle(DSColors.textSecondary(theme: colorScheme))

                        adminSectionCard {
                            adminRow(icon: "square.grid.2x2.fill", title: "Меню и каталог", subtitle: "\(adminStore.products.count) товаров") {
                                AdminCatalogView()
                            }
                            Divider().background(DSColors.divider(theme: colorScheme)).padding(.leading, 48)
                            adminRow(icon: "house.fill", title: "Главная", subtitle: "Новинки, акции") {
                                AdminHomeView()
                            }
                            Divider().background(DSColors.divider(theme: colorScheme)).padding(.leading, 48)
                            adminRow(icon: "mappin.circle.fill", title: "Адреса и локации", subtitle: "\(adminStore.locations.count) точек") {
                                AdminLocationsView()
                            }
                            Divider().background(DSColors.divider(theme: colorScheme)).padding(.leading, 48)
                            adminRow(icon: "tag.fill", title: "Промокоды", subtitle: "\(adminStore.promotions.count) акций") {
                                AdminPromotionsView()
                            }
                        }
                    }
                }
                .padding(DSSpacing.xl)
            }
            .background(DSColors.background(theme: colorScheme))
            .navigationTitle("Панель администратора")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private var useAdminDataToggle: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Использовать данные админа")
                    .font(DSTypography.title)
                    .foregroundStyle(DSColors.textPrimary(theme: colorScheme))
                Text("Меню, главная и адреса будут браться из панели")
                    .font(DSTypography.caption)
                    .foregroundStyle(DSColors.textSecondary(theme: colorScheme))
            }
            Spacer()
            Toggle("", isOn: Binding(
                get: { adminStore.useAdminData },
                set: { adminStore.useAdminData = $0 }
            ))
                .labelsHidden()
                .tint(DSColors.secondary(theme: colorScheme))
        }
        .padding(DSSpacing.lg)
        .background(DSColors.surface(theme: colorScheme))
        .clipShape(RoundedRectangle(cornerRadius: DSCornerRadius.large))
    }

    private func adminSectionCard<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        content()
            .background(DSColors.surface(theme: colorScheme))
            .clipShape(RoundedRectangle(cornerRadius: DSCornerRadius.large))
    }

    private func adminRow<Destination: View>(
        icon: String,
        title: String,
        subtitle: String,
        @ViewBuilder destination: () -> Destination
    ) -> some View {
        NavigationLink(destination: destination) {
            HStack(spacing: DSSpacing.md) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundStyle(DSColors.secondary(theme: colorScheme))
                    .frame(width: 24, alignment: .center)
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(DSTypography.body)
                        .foregroundStyle(DSColors.textPrimary(theme: colorScheme))
                    Text(subtitle)
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
}
