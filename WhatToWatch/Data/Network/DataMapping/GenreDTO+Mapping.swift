//
//  GenreDTO+Mapping.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 22.04.2021.
//

import Foundation

// Data Transfer Object
struct GenreDTO: Mappable, Decodable {

    let name: String?

    func toDomain() -> Genre {
        return .init(name: name)
    }

}
