//
//  CountryDTO+Mapping.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 22.04.2021.
//

import Foundation

// Data Transfer Object
struct CountryDTO: Mappable, Decodable {

    let name: String

    func toDomain() -> Country {
        return .init(name: name)
    }

}
