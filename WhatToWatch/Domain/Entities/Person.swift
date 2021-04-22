//
//  Person.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 22.04.2021.
//

import Foundation

struct Person: Identifiable, Equatable {

    let id: Int
    let name: String?
    let biography: String?
    let birthday: Date?
    let photoPath: String?

}
