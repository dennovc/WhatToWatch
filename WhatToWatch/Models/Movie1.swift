//
//  Movie.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 24.03.2021.
//

import Foundation
import UIKit

struct Movie1: Decodable, Equatable, Hashable {

    // MARK: - Properties

    let id: Int
    let title: String
    let voteAverage: Double
    let releaseDate: String?
    let posterPath: String?
    let overview: String?

    let genres: [Genre1]?
    let countries: [Country1]?
    let runtime: Int?
    let credit: Credit1?

    var releaseYear: String {
        guard
            let releaseDate = releaseDate,
            let date = Utils.dateFormatter.date(from: releaseDate)
        else {
            return "N/A"
        }

        return Utils.yearFormatter.string(from: date)
    }

    // MARK: - Coding Keys

    private enum CodingKeys: String, CodingKey {

        case id
        case title
        case voteAverage = "vote_average"
        case releaseDate = "release_date"
        case posterPath = "poster_path"
        case overview
        case genres
        case countries = "production_countries"
        case runtime
        case credit = "credits"

    }

}
