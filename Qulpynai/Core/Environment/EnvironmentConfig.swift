//
//  EnvironmentConfig.swift
//  Qulpynai
//
//  Environment configuration — staging/production, baseURL, feature flags
//

import Foundation

/// Runtime environment configuration (no hardcoded secrets).
struct EnvironmentConfig {
    enum Flavor: String {
        case development
        case staging
        case production
    }

    let flavor: Flavor
    let baseURL: URL
    let isMock: Bool
    let mockDelay: TimeInterval
    let featureFlags: FeatureFlags

    init(flavor: Flavor) {
        self.flavor = flavor
        switch flavor {
        case .development:
            self.baseURL = URL(string: "https://api-dev.qulpynai.com")!
            self.isMock = true
            self.mockDelay = 0.5
        case .staging:
            self.baseURL = URL(string: "https://api-staging.qulpynai.com")!
            self.isMock = false
            self.mockDelay = 0
        case .production:
            self.baseURL = URL(string: "https://api.qulpynai.com")!
            self.isMock = false
            self.mockDelay = 0
        }
        self.featureFlags = FeatureFlags(flavor: flavor)
    }

    /// Current config based on build.
    static var current: EnvironmentConfig {
        #if DEBUG
        return EnvironmentConfig(flavor: .development)
        #else
        return EnvironmentConfig(flavor: .production)
        #endif
    }
}

extension EnvironmentConfig {
    /// Merchant ID for Apple Pay (configure in xcconfig for production).
    var applePayMerchantId: String {
        switch flavor {
        case .development: return "merchant.dev.qulpynai"
        case .staging: return "merchant.staging.qulpynai"
        case .production: return "merchant.qulpynai"
        }
    }
}

struct FeatureFlags {
    let isApplePayEnabled: Bool
    let isLoyaltyTiersEnabled: Bool
    let isOfflineModeEnabled: Bool
    let isDebugToolsVisible: Bool

    init(flavor: EnvironmentConfig.Flavor) {
        switch flavor {
        case .development:
            isApplePayEnabled = false
            isLoyaltyTiersEnabled = true
            isOfflineModeEnabled = false
            isDebugToolsVisible = true
        case .staging:
            isApplePayEnabled = true
            isLoyaltyTiersEnabled = true
            isOfflineModeEnabled = false
            isDebugToolsVisible = false
        case .production:
            isApplePayEnabled = true
            isLoyaltyTiersEnabled = true
            isOfflineModeEnabled = false
            isDebugToolsVisible = false
        }
    }
}
