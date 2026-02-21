//
//  QulpynaiApp.swift
//  Qulpynai
//
//  Created by Виктор on 21.02.2026.
//

import SwiftUI

@main
struct QulpynaiApp: App {
    @State private var appEnvironment = AppEnvironment()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(\.appEnvironment, appEnvironment)
                .environment(appEnvironment.cartManager)
                .environment(appEnvironment.authManager)
                .environment(appEnvironment.orderManager)
                .environment(appEnvironment.appState)
                .environment(appEnvironment.globalUXState)
        }
    }
}
