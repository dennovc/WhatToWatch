//
//  DetailItemViewModel.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 07.05.2021.
//

import Foundation

struct DetailItemViewModel: Equatable, Hashable {

    let identifier = UUID()

    let title: String
    let overview: String
    let description: String?
    let rating: Double?
    let date: Date?
    let country: String?
    let runtime: [TimeInterval]?
    let imagePath: String?

}

// MARK: - Initialization

extension DetailItemViewModel {

    init(media: Media) {
        switch media {
        case .movie(let movie): self.init(movie)
        case .tv(let tv): self.init(tv)
        case .person(let person): self.init(person)
        }
    }

    private init(_ movie: Movie) {
        title = movie.title
        overview = movie.overview
        description = movie.genres?.map(\.name).joined(separator: ", ")
        rating = movie.rating
        date = movie.releaseDate
        country = movie.productionCountries?.map(\.name).joined(separator: ", ")
        runtime = movie.runtime != nil ? [movie.runtime!] : nil
        imagePath = movie.posterPath
    }

    private init(_ tv: TV) {
        title = tv.title
        overview = tv.overview
        description = tv.genres?.map(\.name).joined(separator: ", ")
        rating = tv.rating
        date = tv.firstAirDate
        country = tv.productionCountries?.map(\.name).joined(separator: ", ")
        runtime = tv.episodeRuntime
        imagePath = tv.posterPath
    }

    private init(_ person: Person) {
        title = person.name
        overview = person.biography
        description = person.knownForDepartment
        rating = nil
        date = person.birthday
        country = person.placeOfBirth
        runtime = nil
        imagePath = person.photoPath
    }

}
