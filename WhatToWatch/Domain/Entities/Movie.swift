//
//  Movie.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 22.04.2021.
//

import Foundation

struct Movie: Identifiable, Equatable {

    let id: Int
    let title: String
    let overview: String
    let releaseDate: Date?
    let rating: Double?
    let posterPath: String?
    let backdropPath: String?
    let runtime: TimeInterval?
    let credit: Credit?
    let genres: [Genre]?
    let productionCountries: [Country]?

}
