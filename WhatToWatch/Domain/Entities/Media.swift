//
//  Media.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 02.05.2021.
//

import Foundation

enum MediaType {

    case movie
    case tv
    case person

}

enum Media: Equatable {

    case movie(Movie)
    case tv(TV)
    case person(Person)

}
