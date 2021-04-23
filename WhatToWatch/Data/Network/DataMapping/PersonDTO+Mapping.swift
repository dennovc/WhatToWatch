//
//  PersonDTO+Mapping.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 23.04.2021.
//

import Foundation

// Data Transfer Object
struct PersonDTO: Mappable, Decodable {

    let id: Int
    let name: String?
    let biography: String?
    let birthday: String?
    let photoPath: String?
    let knownForDepartment: String?
    let placeOfBirth: String?

    func toDomain() -> Person {
        return .init(id: id,
                     name: name,
                     biography: biography,
                     birthday: dateFormatter.date(from: birthday ?? ""),
                     photoPath: photoPath,
                     knownForDepartment: knownForDepartment,
                     placeOfBirth: placeOfBirth)
    }

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-mm-dd"
        return formatter
    }()

}

// MARK: - Coding Keys

private extension PersonDTO {

    enum CodingKeys: String, CodingKey {

        case id
        case name
        case biography
        case birthday
        case photoPath = "profile_path"
        case knownForDepartment = "known_for_department"
        case placeOfBirth = "place_of_birth"

    }

}
