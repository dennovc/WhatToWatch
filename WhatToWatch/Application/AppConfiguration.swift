//
//  AppConfiguration.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 03.05.2021.
//

import Foundation

final class AppConfiguration {

    private(set) lazy var apiKey: String = {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "APIKey") as? String else {
            fatalError("APIKey must not be empty in plist")
        }
        return apiKey
    }()

    private(set) lazy var apiBaseURL: String = {
        guard let apiBaseURL = Bundle.main.object(forInfoDictionaryKey: "APIBaseURL") as? String else {
            fatalError("APIBaseURL must not be empty in plist")
        }
        return apiBaseURL
    }()

    private(set) lazy var imageBaseURL: String = {
        guard let imageBaseURL = Bundle.main.object(forInfoDictionaryKey: "ImageBaseURL") as? String else {
            fatalError("ImageBaseURL must not be empty in plist")
        }
        return imageBaseURL
    }()

}
