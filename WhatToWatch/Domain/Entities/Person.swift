//
//  Person.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 22.04.2021.
//

import Foundation

struct Person: Identifiable, Equatable, Hashable {

    let id: Int
    let name: String
    let biography: String
    let birthday: Date?
    let photoPath: String?
    let knownForDepartment: String?
    let placeOfBirth: String?
    let knownFor: KnownFor?

}

// MARK: - Initialization

extension Person {

    init(cast: Cast) {
        id = cast.personID
        name = cast.name
        biography = ""
        photoPath = cast.photoPath
        knownForDepartment = cast.character

        birthday = nil
        placeOfBirth = nil
        knownFor = nil
    }

}
