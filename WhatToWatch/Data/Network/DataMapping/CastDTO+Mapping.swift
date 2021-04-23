//
//  CastDTO+Mapping.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 22.04.2021.
//

import Foundation

// Data Transfer Object
struct CastDTO: Mappable, Decodable {

    let personID: Int?
    let name: String?
    let character: String?
    let photoPath: String?

    func toDomain() -> Cast {
        return .init(personID: personID,
                     name: name,
                     character: character,
                     photoPath: photoPath)
    }

}

// MARK: - Coding Keys

private extension CastDTO {

    enum CodingKeys: String, CodingKey {

        case personID = "id"
        case name
        case character
        case photoPath = "profile_path"

    }

}
