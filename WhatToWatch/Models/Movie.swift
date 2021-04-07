//
//  Movie.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 24.03.2021.
//

import Foundation
import UIKit

struct Movie: Decodable, Equatable {

    // MARK: - Properties

    let id: Int
    let title: String
    let voteAverage: Double
    let releaseDate: String?
    let posterPath: String?

    // MARK: - Coding Keys

    private enum CodingKeys: String, CodingKey {

        case id
        case title
        case voteAverage = "vote_average"
        case releaseDate = "release_date"
        case posterPath = "poster_path"

    }

}
