//
//  MediaPageDTO+Mapping.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 23.04.2021.
//

import Foundation

// Data Transfer Object
struct MediaPageDTO<MediaDTO: Mappable & Decodable>: Mappable, Decodable {

    let page: Int
    let totalPages: Int
    let media: [MediaDTO]

    func toDomain() -> MediaPage<MediaDTO.Result> {
        return .init(page: page,
                     totalPages: totalPages,
                     media: media.map { $0.toDomain() })
    }

}

typealias MoviesPageDTO = MediaPageDTO<MovieDTO>
typealias TVPageDTO = MediaPageDTO<TVDTO>
typealias PersonsPageDTO = MediaPageDTO<PersonDTO>

// MARK: - Coding Keys

private extension MediaPageDTO {

    enum CodingKeys: String, CodingKey {

        case page
        case totalPages = "total_pages"
        case media = "results"

    }

}
