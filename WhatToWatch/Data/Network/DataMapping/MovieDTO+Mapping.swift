//
//  MovieDTO+Mapping.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 22.04.2021.
//

import Foundation

// Data Transfer Object
struct MovieDTO: Mappable, Decodable {

    let id: Int
    let title: String
    let overview: String
    let releaseDate: String?
    let rating: Double?
    let posterPath: String?
    let backdropPath: String?
    let runtime: Int?
    let credit: CreditDTO?
    let genres: [GenreDTO]?
    let productionCountries: [CountryDTO]?

    func toDomain() -> Movie {
        return .init(id: id,
                     title: title,
                     overview: overview,
                     releaseDate: dateFormatter.date(from: releaseDate ?? ""),
                     rating: rating,
                     posterPath: posterPath,
                     backdropPath: backdropPath,
                     runtime: runtime != nil ? Double(runtime!) * 60.0 : nil,
                     credit: credit?.toDomain(),
                     genres: genres?.map { $0.toDomain() },
                     productionCountries: productionCountries?.map { $0.toDomain() })
    }

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-mm-dd"
        return formatter
    }()

}

// MARK: - Coding Keys

private extension MovieDTO {

    enum CodingKeys: String, CodingKey {

        case id
        case title
        case overview
        case releaseDate = "release_date"
        case rating = "vote_average"
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case runtime
        case credit = "credits"
        case genres
        case productionCountries = "production_countries"

    }

}
