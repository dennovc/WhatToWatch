//
//  Media.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 02.05.2021.
//

import Foundation

enum MediaType {

    case movie
    case tv
    case person

}

enum Media: Equatable, Hashable {

    case movie(Movie)
    case tv(TV)
    case person(Person)

    // MARK: - Properties

    var id: Int {
        switch self {
        case .movie(let movie): return movie.id
        case .tv(let tv): return tv.id
        case .person(let person): return person.id
        }
    }

    var type: MediaType {
        switch self {
        case .movie: return .movie
        case .tv: return .tv
        case .person: return .person
        }
    }

}
