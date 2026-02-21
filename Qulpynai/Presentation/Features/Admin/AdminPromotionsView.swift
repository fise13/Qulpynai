//
//  AdminPromotionsView.swift
//  Qulpynai
//
//  Admin — promotions
//

import SwiftUI

struct AdminPromotionsView: View {
    @Environment(AdminStore.self) private var adminStore
    @State private var showAdd = false
    @State private var editingPromo: AdminPromotion?
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        List {
            ForEach(adminStore.promotions) { promo in
                Button {
                    editingPromo = promo
                } label: {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(promo.code)
                            .font(DSTypography.title)
                            .foregroundStyle(DSColors.textPrimary(theme: colorScheme))
                        Text("\(promo.typeRaw) \(promo.value)")
                            .font(DSTypography.caption)
                            .foregroundStyle(DSColors.textSecondary(theme: colorScheme))
                    }
                }
                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                    Button(role: .destructive) {
                        adminStore.deletePromotion(id: promo.id)
                    } label: {
                        Label("Удалить", systemImage: "trash")
                    }
                }
            }
        }
        .listStyle(.plain)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showAdd = true
                } label: {
                    Image(systemName: "plus.circle.fill")
                }
            }
        }
        .sheet(isPresented: $showAdd) {
            AdminPromotionFormView(promotion: nil) { p in
                adminStore.addPromotion(p)
            }
        }
        .sheet(item: $editingPromo) { promo in
            AdminPromotionFormView(promotion: promo) { updated in
                adminStore.updatePromotion(updated)
            }
        }
        .navigationTitle("Промокоды")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AdminPromotionFormView: View {
    let promotion: AdminPromotion?
    let onSave: (AdminPromotion) -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var code: String = ""
    @State private var typeRaw: String = "percent"
    @State private var valueText: String = ""
    @State private var minOrderText: String = ""

    var body: some View {
        NavigationStack {
            Form {
                TextField("Код", text: $code)
                Picker("Тип", selection: $typeRaw) {
                    Text("Процент").tag("percent")
                    Text("Фикс. сумма").tag("fixedAmount")
                }
                TextField("Значение", text: $valueText)
                    .keyboardType(.decimalPad)
                TextField("Мин. сумма заказа", text: $minOrderText)
                    .keyboardType(.decimalPad)
            }
            .navigationTitle(promotion == nil ? "Новый промокод" : "Редактировать")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отмена") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Сохранить") {
                        guard let val = Decimal(string: valueText.replacingOccurrences(of: ",", with: ".")) else { return }
                        let minOrder = Decimal(string: minOrderText.replacingOccurrences(of: ",", with: "."))
                        let id = promotion?.id ?? UUID().uuidString
                        onSave(AdminPromotion(id: id, code: code.uppercased(), typeRaw: typeRaw, value: val, minOrderAmount: minOrder, expiresAt: nil))
                        dismiss()
                    }
                    .disabled(code.isEmpty || valueText.isEmpty)
                }
            }
            .onAppear {
                code = promotion?.code ?? ""
                typeRaw = promotion?.typeRaw ?? "percent"
                valueText = promotion.map { "\($0.value)" } ?? ""
                minOrderText = promotion?.minOrderAmount.map { "\($0)" } ?? ""
            }
        }
    }
}
