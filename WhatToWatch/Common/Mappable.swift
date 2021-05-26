//
//  Mappable.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 23.04.2021.
//

import Foundation

/// Indicating that DTOs structs can be mapped to Domains.
protocol Mappable {

    /// A result type.
    associatedtype Result

    /**
     Maps to Domains.

     - Returns: Domain struct.
     */
    func toDomain() -> Result

}
