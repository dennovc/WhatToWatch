//
//  ResponseDecoder.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 17.04.2021.
//

import Foundation

/// An object that decodes instances of a data type.
protocol ResponseDecoder {

    /**
     Returns a value of the type you specify, decoded from a data object.

     - Parameter data: The data object to decode.

     - Throws: `DecodingError` If a value fails to decode.

     - Returns: Value, decoded from `data`.
     */
    func decode<T: Decodable>(_ data: Data) throws -> T

}
