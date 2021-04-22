//
//  MediaPage.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 22.04.2021.
//

import Foundation

struct MediaPage<T> {

    let page: Int
    let totalPages: Int
    let media: [T]

}

typealias MoviesPage = MediaPage<Movie>
typealias TVPage = MediaPage<TV>
typealias PersonsPage = MediaPage<Person>
