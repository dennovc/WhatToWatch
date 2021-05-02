//
//  MediaDTO+Mapping.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 02.05.2021.
//

import Foundation

// Data Transfer Object
enum MediaDTO: Mappable, Decodable {

    case movie(MovieDTO)
    case tv(TVDTO)
    case person(PersonDTO)

    func toDomain() -> Media {
        switch self {
        case .movie(let movie): return .movie(movie.toDomain())
        case .tv(let tv): return .tv(tv.toDomain())
        case .person(let person): return .person(person.toDomain())
        }
    }

}

// MARK: - Decoding

extension MediaDTO {

    private enum CodingKeys: String, CodingKey {

        case `default` = ""

    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let value = try? container.decode(MovieDTO.self) {
            self = .movie(value)
            return
        }
        if let value = try? container.decode(TVDTO.self) {
            self = .tv(value)
            return
        }
        if let value = try? container.decode(PersonDTO.self) {
            self = .person(value)
            return
        }

        let context = DecodingError.Context(codingPath: [CodingKeys.default],
                                            debugDescription: "Expected Media type")
        throw DecodingError.typeMismatch(MediaDTO.self, context)
    }

}
