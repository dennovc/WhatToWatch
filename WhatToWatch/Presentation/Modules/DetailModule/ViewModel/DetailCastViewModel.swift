//
//  DetailCastViewModel.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 07.05.2021.
//

import Foundation

struct DetailCastViewModel: Equatable, Hashable {

    let identifier = UUID()

    let title: String
    let description: String?
    let imagePath: String?

}

// MARK: - Initialization

extension DetailCastViewModel {

    init(media: Media) {
        switch media {
        case .movie(let movie): self.init(movie)
        case .tv(let tv): self.init(tv)
        case .person(let person): self.init(person)
        }
    }

    private init(_ movie: Movie) {
        title = movie.title
        description = nil
        imagePath = movie.posterPath
    }

    private init(_ tv: TV) {
        title = tv.title
        description = nil
        imagePath = tv.posterPath
    }

    private init(_ person: Person) {
        title = person.name
        description = person.knownForDepartment
        imagePath = person.photoPath
    }

}
