//
//  TV.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 25.03.2021.
//

import UIKit

struct TV1: Decodable, Equatable, Hashable {

    // MARK: - Properties

    let id: Int
    let title: String
    let voteAverage: Double
    let firstAirDate: String?
    let posterPath: String?
    let overview: String?

    let genres: [Genre1]?
    let countries: [Country1]?
    let credit: Credit1?

    var releaseYear: String {
        guard
            let releaseDate = firstAirDate,
            let date = Utils.dateFormatter.date(from: releaseDate)
        else {
            return "N/A"
        }

        return Utils.yearFormatter.string(from: date)
    }

    // MARK: - Coding Keys

    private enum CodingKeys: String, CodingKey {

        case id
        case title = "name"
        case voteAverage = "vote_average"
        case firstAirDate = "first_air_date"
        case posterPath = "poster_path"
        case overview
        case genres
        case countries = "production_countries"
        case credit = "credits"

    }

}
