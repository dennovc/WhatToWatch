//
//  TV.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 25.03.2021.
//

struct TV: Decodable, Equatable {

    // MARK: - Properties

    let id: Int
    let title: String

    // MARK: - Coding Keys

    private enum CodingKeys: String, CodingKey {

        case id
        case title = "name"

    }

}
