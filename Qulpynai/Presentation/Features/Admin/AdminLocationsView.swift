//
//  AdminLocationsView.swift
//  Qulpynai
//
//  Admin — locations (addresses)
//

import SwiftUI

struct AdminLocationsView: View {
    @Environment(AdminStore.self) private var adminStore
    @State private var showAdd = false
    @State private var editingLocation: AdminLocation?
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        List {
            ForEach(adminStore.locations) { loc in
                Button {
                    editingLocation = loc
                } label: {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(loc.name)
                            .font(DSTypography.title)
                            .foregroundStyle(DSColors.textPrimary(theme: colorScheme))
                        Text(loc.address)
                            .font(DSTypography.caption)
                            .foregroundStyle(DSColors.textSecondary(theme: colorScheme))
                        if !loc.isOpen {
                            Text("Закрыто")
                                .font(DSTypography.captionSmall)
                                .foregroundStyle(DSColors.error(theme: colorScheme))
                        }
                    }
                }
                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                    Button(role: .destructive) {
                        adminStore.deleteLocation(id: loc.id)
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
            AdminLocationFormView(location: nil) { l in
                adminStore.addLocation(l)
            }
        }
        .sheet(item: $editingLocation) { loc in
            AdminLocationFormView(location: loc) { updated in
                adminStore.updateLocation(updated)
            }
        }
        .navigationTitle("Адреса")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AdminLocationFormView: View {
    let location: AdminLocation?
    let onSave: (AdminLocation) -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var name: String = ""
    @State private var address: String = ""
    @State private var isOpen: Bool = true

    var body: some View {
        NavigationStack {
            Form {
                TextField("Название", text: $name)
                TextField("Адрес", text: $address)
                Toggle("Открыто", isOn: $isOpen)
            }
            .navigationTitle(location == nil ? "Новая локация" : "Редактировать")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отмена") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Сохранить") {
                        let id = location?.id ?? UUID().uuidString
                        onSave(AdminLocation(id: id, name: name, address: address, isOpen: isOpen))
                        dismiss()
                    }
                    .disabled(name.isEmpty || address.isEmpty)
                }
            }
            .onAppear {
                name = location?.name ?? ""
                address = location?.address ?? ""
                isOpen = location?.isOpen ?? true
            }
        }
    }
}
