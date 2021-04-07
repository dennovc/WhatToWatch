//
//  Person.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 25.03.2021.
//

struct Person: Decodable, Equatable {

    // MARK: - Cases

    let id: Int
    let name: String
    let pathToPhoto: String?

    // MARK: - Coding Keys

    private enum CodingKeys: String, CodingKey {

        case id
        case name
        case pathToPhoto = "profile_path"

    }

}
