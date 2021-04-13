//
//  Cast.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 08.04.2021.
//

struct Cast: Decodable, Equatable, Hashable {

    let id: Int
    let name: String
    let character: String
    let pathToPhoto: String?

    private enum CodingKeys: String, CodingKey {

        case id
        case name
        case character
        case pathToPhoto = "profile_path"

    }

}
