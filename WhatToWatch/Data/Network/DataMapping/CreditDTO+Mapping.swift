//
//  CreditDTO+Mapping.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 22.04.2021.
//

import Foundation

// Data Transfer Object
struct CreditDTO: Mappable, Decodable {

    let cast: [CastDTO]?

    func toDomain() -> Credit {
        return .init(cast: cast?.map { $0.toDomain() })
    }

}
