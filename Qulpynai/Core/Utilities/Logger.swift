//
//  Logger.swift
//  Qulpynai
//
//  Debug logging — no-op in release
//

import Foundation

enum Logger {
    static func debug(_ message: String) {
        #if DEBUG
        print("[Qulpynai] \(message)")
        #endif
    }

    static func error(_ message: String) {
        #if DEBUG
        print("[Qulpynai ERROR] \(message)")
        #endif
    }
}
