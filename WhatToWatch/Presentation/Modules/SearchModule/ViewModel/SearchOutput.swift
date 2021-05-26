//
//  SearchOutput.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 02.04.2021.
//

import Foundation
import RxCocoa

enum SearchLoading {

    case fullScreen
    case nextPage

}

enum SearchError: LocalizedError {

    case underlyingError(Error)
    case notFound
    case unknown

    var errorDescription: String? {
        switch self {
        case .underlyingError(let error): return error.localizedDescription
        case .notFound: return "No results"
        case .unknown: return "Unknown error"
        }
    }

}

protocol SearchOutput {

    var scopeButtonTitles: Driver<[String]> { get }
    var searchBarPlaceholder: Driver<String> { get }

    var items: Driver<[SearchItemViewModel]> { get }
    var loading: Driver<SearchLoading?> { get }
    var error: Driver<SearchError?> { get }

}
