//
//  Mappable.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 23.04.2021.
//

import Foundation

protocol Mappable {

    associatedtype Result

    func toDomain() -> Result

}
