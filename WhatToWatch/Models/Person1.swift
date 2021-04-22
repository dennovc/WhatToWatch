//
//  Person.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 25.03.2021.
//

struct Person1: Decodable, Equatable, Hashable {

    // MARK: - Cases

    let id: Int
    let name: String
    let pathToPhoto: String?

    let birthday: String?
    let biography: String?

    // MARK: - Coding Keys

    private enum CodingKeys: String, CodingKey {

        case id
        case name
        case pathToPhoto = "profile_path"
        case birthday
        case biography

    }

}
