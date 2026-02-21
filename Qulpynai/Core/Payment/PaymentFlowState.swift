//
//  PaymentFlowState.swift
//  Qulpynai
//
//  Payment flow state machine
//

import Foundation

enum PaymentFlowState: Equatable {
    case idle
    case preparing
    case authorizing
    case verifying
    case succeeded(transactionId: String)
    case failed(errorMessage: String)
    case retryableFailed(errorMessage: String)
}
