//
//  DiscoverItemViewModel.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 04.05.2021.
//

import Foundation

struct DiscoverItemViewModel: Equatable, Hashable {

    let identifier = UUID()
    let imagePath: String?

}

// MARK: - Initialization

extension DiscoverItemViewModel {

    init(media: Media) {
        switch media {
        case .movie(let movie): self.init(movie)
        case .tv(let tv): self.init(tv)
        case .person(let person): self.init(person)
        }
    }

    private init(_ movie: Movie) {
        imagePath = movie.posterPath
    }

    private init(_ tv: TV) {
        imagePath = tv.backdropPath
    }

    private init(_ person: Person) {
        fatalError("init(person:) has not been implemented")
    }

}
