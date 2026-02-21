//
//  GlobalUXState.swift
//  Qulpynai
//
//  Global loading overlay, error bus, offline placeholder
//

import Foundation

@Observable
final class GlobalUXState {
    var isLoadingOverlayVisible: Bool = false
    var lastError: Error?
    var isOffline: Bool = false

    func showLoading() {
        isLoadingOverlayVisible = true
    }

    func hideLoading() {
        isLoadingOverlayVisible = false
    }

    func showError(_ error: Error) {
        lastError = error
    }

    func clearError() {
        lastError = nil
    }
}
