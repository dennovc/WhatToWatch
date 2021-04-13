//
//  DiscoverOutput.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 13.04.2021.
//

import UIKit
import RxCocoa

protocol DiscoverOutput: class {

    var trendingMoviesOfDay: Driver<[SearchResult]> { get }
    var trendingTVOfDay: Driver<[SearchResult]> { get }
    var trendingMoviesOfWeek: Driver<[SearchResult]> { get }
    var trendingTVOfWeek: Driver<[SearchResult]> { get }

    func loadImage(path: String?, completion: @escaping (UIImage?) -> Void)

}
