//
//  Loadable.swift
//  Qulpynai
//
//  Loading/Error state
//

import Foundation

enum Loadable<T> {
    case idle
    case loading
    case loaded(T)
    case error(Error)
}
