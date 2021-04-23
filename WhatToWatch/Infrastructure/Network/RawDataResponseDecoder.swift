//
//  RawDataResponseDecoder.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 23.04.2021.
//

import Foundation

final class RawDataResponseDecoder {

    private enum CodingKeys: String, CodingKey {

        case `default` = ""

    }

}

// MARK: - Response Decoder

extension RawDataResponseDecoder: ResponseDecoder {

    func decode<T: Decodable>(_ data: Data) throws -> T {
        guard let data = data as? T else {
            let context = DecodingError.Context(codingPath: [CodingKeys.default],
                                                debugDescription: "Expected Data type")
            throw DecodingError.typeMismatch(T.self, context)
        }

        return data
    }

}
