//
//  DiscoverInput.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 13.04.2021.
//

import Foundation

enum DiscoverSection: String, CaseIterable {

    case moviesOfDay = "Movies Of The Day"
    case tvOfDay = "TV Of The Day"
    case moviesOfWeek = "Movies Of The Week"
    case tvOfWeek = "TV Of The Week"

}

protocol DiscoverInput {

    func viewDidLoad()
    func didSelectItem(at index: Int, in section: DiscoverSection)
    func didLoadNextPage(for section: DiscoverSection)

}
