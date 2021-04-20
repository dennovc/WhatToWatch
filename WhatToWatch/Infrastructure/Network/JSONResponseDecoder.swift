//
//  JSONResponseDecoder.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 17.04.2021.
//

import Foundation

final class JSONResponseDecoder {

    private let jsonDecoder = JSONDecoder()

}

// MARK: - Response Decoder

extension JSONResponseDecoder: ResponseDecoder {

    func decode<T: Decodable>(_ data: Data) throws -> T {
        return try jsonDecoder.decode(T.self, from: data)
    }

}
