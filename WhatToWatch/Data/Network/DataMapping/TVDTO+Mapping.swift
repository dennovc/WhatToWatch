//
//  TVDTO+Mapping.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 23.04.2021.
//

import Foundation

// Data Transfer Object
struct TVDTO: Mappable, Decodable {

    let id: Int
    let title: String?
    let overview: String?
    let firstAirDate: String?
    let rating: Double?
    let posterPath: String?
    let backdropPath: String?
    let episodeRuntime: [Int]?
    let credit: CreditDTO?
    let genres: [GenreDTO]?
    let productionCountries: [CountryDTO]?

    func toDomain() -> TV {
        return .init(id: id,
                     title: title,
                     overview: overview,
                     firstAirDate: dateFormatter.date(from: firstAirDate ?? ""),
                     rating: rating,
                     posterPath: posterPath,
                     backdropPath: backdropPath,
                     episodeRuntime: episodeRuntime?.map { Double($0) * 60.0 },
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

private extension TVDTO {

    enum CodingKeys: String, CodingKey {

        case id
        case title = "name"
        case overview
        case firstAirDate = "first_air_date"
        case rating = "vote_average"
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case episodeRuntime = "episode_run_time"
        case credit = "credits"
        case genres
        case productionCountries = "production_countries"

    }

}
