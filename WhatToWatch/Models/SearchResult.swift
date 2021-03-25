//
//  SearchResult.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 24.03.2021.
//

struct SearchResult<T: Decodable>: Decodable {

    // MARK: - Properties

    let results: [T]
    let numberOfPages: Int

    // MARK: - Coding Keys

    private enum CodingKeys: String, CodingKey {

        case results
        case numberOfPages = "total_pages"

    }

}
