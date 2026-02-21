//
//  AppLogger.swift
//  Qulpynai
//
//  Logging abstraction — no-op in production
//

import Foundation

/// Centralized logging; calls suppressed in Release.
enum AppLogger {
    static func debug(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        #if DEBUG
        let filename = (file as NSString).lastPathComponent
        print("[Qulpynai] [\(filename):\(line)] \(message)")
        #endif
    }

    static func error(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        #if DEBUG
        let filename = (file as NSString).lastPathComponent
        print("[Qulpynai ERROR] [\(filename):\(line)] \(message)")
        #endif
    }
}
