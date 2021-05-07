//
//  DetailCastViewModel.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 07.05.2021.
//

import Foundation

struct DetailCastViewModel: Equatable, Hashable {

    let identifier = UUID()

    let title: String
    let description: String?
    let imagePath: String?

}

// MARK: - Initialization

extension DetailCastViewModel {

    init(cast: Cast) {
        title = cast.name
        description = cast.character
        imagePath = cast.photoPath
    }

}
