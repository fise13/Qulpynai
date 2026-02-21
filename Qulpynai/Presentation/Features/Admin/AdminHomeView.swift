//
//  AdminHomeView.swift
//  Qulpynai
//
//  Admin — home: featured products, promo banner
//

import SwiftUI

struct AdminHomeView: View {
    @Environment(AdminStore.self) private var adminStore
    @State private var bannerTitle: String = ""
    @State private var bannerSubtitle: String = ""
    @State private var bannerCode: String = ""
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        Form {
            Section {
                TextField("Заголовок", text: $bannerTitle)
                TextField("Подзаголовок", text: $bannerSubtitle)
                TextField("Промокод", text: $bannerCode)
            } header: {
                Text("Баннер на главной")
            } footer: {
                Text("Этот баннер отображается на главном экране")
            }

            Section {
                ForEach(adminStore.products) { p in
                    let isFeatured = adminStore.featuredProductIds.contains(p.id)
                    Button {
                        toggleFeatured(p.id)
                    } label: {
                        HStack {
                            AdminProductRow(product: p)
                            Spacer()
                            if isFeatured {
                                Image(systemName: "star.fill")
                                    .foregroundStyle(DSColors.secondary(theme: colorScheme))
                            }
                        }
                    }
                }
            } header: {
                Text("Популярное / Новинки")
            } footer: {
                Text("Отметьте товары для блока «Популярное» на главной. Порядок можно менять перетаскиванием.")
            }
        }
        .navigationTitle("Главная")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            bannerTitle = adminStore.promoBanner.title
            bannerSubtitle = adminStore.promoBanner.subtitle
            bannerCode = adminStore.promoBanner.code
        }
        .onChange(of: bannerTitle) { _, _ in adminStore.updatePromoBanner(title: bannerTitle, subtitle: bannerSubtitle, code: bannerCode) }
        .onChange(of: bannerSubtitle) { _, _ in adminStore.updatePromoBanner(title: bannerTitle, subtitle: bannerSubtitle, code: bannerCode) }
        .onChange(of: bannerCode) { _, _ in adminStore.updatePromoBanner(title: bannerTitle, subtitle: bannerSubtitle, code: bannerCode) }
    }

    private func toggleFeatured(_ id: String) {
        var ids = adminStore.featuredProductIds
        if ids.contains(id) {
            ids.removeAll { $0 == id }
        } else {
            ids.append(id)
        }
        adminStore.setFeatured(ids: ids)
    }
}
