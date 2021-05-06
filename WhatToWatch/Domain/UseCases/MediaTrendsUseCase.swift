//
//  MediaTrendsUseCase.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 02.05.2021.
//

import Foundation

protocol MediaTrendsUseCase {

    typealias CompletionHandler = (Result<MediaPage, Error>) -> Void

    @discardableResult
    func fetchTrends(type: MediaType,
                     timeWindow: TimeWindow,
                     page: Int,
                     completion: @escaping CompletionHandler) -> Cancellable?

}
