//
//  Utils.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 05.04.2021.
//

import Foundation

final class Utils {

    // MARK: - Life Cycle

    private init() {}

    // MARK: - Static Properties

    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-mm-dd"
        return formatter
    }()

    static let yearFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter
    }()

}
