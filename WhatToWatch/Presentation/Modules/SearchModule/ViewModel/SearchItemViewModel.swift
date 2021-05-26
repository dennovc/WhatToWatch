//
//  SearchItemViewModel.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 08.05.2021.
//

import Foundation

struct SearchItemViewModel: Equatable, Hashable {

    let identifier = UUID()

    let title: String
    let rating: Double?
    let date: Date?
    let imagePath: String?

}

// MARK: - Initialization

extension SearchItemViewModel {

    init(media: Media) {
        switch media {
        case .movie(let movie): self.init(movie)
        case .tv(let tv): self.init(tv)
        case .person(let person): self.init(person)
        }
    }

    private init(_ movie: Movie) {
        title = movie.title
        rating = movie.rating
        date = movie.releaseDate
        imagePath = movie.posterPath
    }

    private init(_ tv: TV) {
        title = tv.title
        rating = tv.rating
        date = tv.firstAirDate
        imagePath = tv.posterPath
    }

    private init(_ person: Person) {
        title = person.name
        rating = nil
        date = nil
        imagePath = person.photoPath
    }

}
