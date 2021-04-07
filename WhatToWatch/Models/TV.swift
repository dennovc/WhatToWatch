//
//  TV.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 25.03.2021.
//

import UIKit

struct TV: Decodable, Equatable {

    // MARK: - Properties

    let id: Int
    let title: String
    let voteAverage: Double
    let firstAirDate: String?
    let posterPath: String?

    // MARK: - Coding Keys

    private enum CodingKeys: String, CodingKey {

        case id
        case title = "name"
        case voteAverage = "vote_average"
        case firstAirDate = "first_air_date"
        case posterPath = "poster_path"

    }

}
