//
//  AppConfiguration.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 03.05.2021.
//

import Foundation

final class AppConfiguration {

    private let apiInfo: NSDictionary = {
        guard let path = Bundle.main.path(forResource: "API-Info", ofType: "plist") else {
            fatalError("Couldn't find file 'API-Info.plist'.")
        }

        return NSDictionary(contentsOfFile: path)!
    }()

    private(set) lazy var apiKey: String = {
        guard let apiKey = apiInfo.object(forKey: "APIKey") as? String else {
            fatalError("APIKey must not be empty in plist")
        }
        return apiKey
    }()

    private(set) lazy var apiBaseURL: String = {
        guard let apiBaseURL = apiInfo.object(forKey: "APIBaseURL") as? String else {
            fatalError("APIBaseURL must not be empty in plist")
        }
        return apiBaseURL
    }()

    private(set) lazy var imageBaseURL: String = {
        guard let imageBaseURL = apiInfo.object(forKey: "ImageBaseURL") as? String else {
            fatalError("ImageBaseURL must not be empty in plist")
        }
        return imageBaseURL
    }()

}
