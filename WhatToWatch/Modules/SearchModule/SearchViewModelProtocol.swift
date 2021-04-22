//
//  SearchViewModelProtocol.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 02.04.2021.
//

import Foundation

protocol SearchViewModelProtocol: class {

    var input: SearchInput { get }
    var output: SearchOutput { get }

}

// MARK: - Search Result

enum SearchResult: Hashable {

    case movie(Movie1)
    case tv(TV1)
    case person(Person1)

}

// MARK: - Search Error

enum SearchError: LocalizedError {

    // MARK: - Cases

    case underlyingError(Error)
    case notFound
    case unknown

    // MARK: - Properties

    var errorDescription: String? {
        switch self {
        case .underlyingError(let error): return error.localizedDescription
        case .notFound: return "No results"
        case .unknown: return "Unknown error"
        }
    }

}
