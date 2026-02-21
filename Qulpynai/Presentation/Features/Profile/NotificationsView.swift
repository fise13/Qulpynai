//
//  NotificationsView.swift
//  Qulpynai
//

import SwiftUI

struct NotificationsView: View {
    @AppStorage("prefNotifications") private var notificationsEnabled = true
    @AppStorage("prefOrderUpdates") private var orderUpdates = true
    @AppStorage("prefPromos") private var promos = false

    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        List {
            Section("Order Updates") {
                Toggle("Order status", isOn: $orderUpdates)
            }
            Section("Promotions") {
                Toggle("Offers & promos", isOn: $promos)
            }
            Section {
                Toggle("Enable notifications", isOn: $notificationsEnabled)
            }
        }
        .navigationTitle("Notifications")
        .navigationBarTitleDisplayMode(.inline)
    }
}
