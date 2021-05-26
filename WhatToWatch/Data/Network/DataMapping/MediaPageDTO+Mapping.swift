//
//  MediaPageDTO+Mapping.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 23.04.2021.
//

import Foundation

// Data Transfer Object
struct MediaPageDTO: Mappable, Decodable {

    let page: Int
    let totalPages: Int
    let media: [MediaDTO]

    func toDomain() -> MediaPage {
        return .init(page: page,
                     totalPages: totalPages,
                     media: media.map { $0.toDomain() })
    }

}

// MARK: - Coding Keys

private extension MediaPageDTO {

    enum CodingKeys: String, CodingKey {

        case page
        case totalPages = "total_pages"
        case media = "results"

    }

}
