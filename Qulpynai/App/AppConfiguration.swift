//
//  AppConfiguration.swift
//  Qulpynai
//
//  Environment configuration — feeds EnvironmentConfig
//

import Foundation

enum AppConfiguration {
    case development
    case staging
    case production

    static var current: AppConfiguration {
        #if DEBUG
        return .development
        #else
        return .production
        #endif
    }

    var config: EnvironmentConfig {
        let flavor: EnvironmentConfig.Flavor
        switch self {
        case .development: flavor = .development
        case .staging: flavor = .staging
        case .production: flavor = .production
        }
        return EnvironmentConfig(flavor: flavor)
    }

    var isMock: Bool { config.isMock }
    var apiBaseURL: URL { config.baseURL }
    var mockDelay: TimeInterval { config.mockDelay }
}
