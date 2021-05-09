//
//  KnownForDTO.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 10.05.2021.
//

import Foundation

// Data Transfer Object
struct KnownForDTO: Mappable, Decodable {

    let cast: [MediaDTO]?

    func toDomain() -> KnownFor {
        return .init(cast: cast?.map { $0.toDomain() })
    }

}
