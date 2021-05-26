//
//  DefaultMediaTrendsUseCase.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 02.05.2021.
//

import Foundation

final class DefaultMediaTrendsUseCase {

    private let mediaRepository: MediaRepository

    init(mediaRepository: MediaRepository) {
        self.mediaRepository = mediaRepository
    }

}

// MARK: - Media Trends Use Case

extension DefaultMediaTrendsUseCase: MediaTrendsUseCase {

    func fetchTrends(type: MediaType,
                     timeWindow: TimeWindow,
                     page: Int,
                     completion: @escaping CompletionHandler) -> Cancellable? {
        return mediaRepository.fetchTrends(type: type,
                                           timeWindow: timeWindow,
                                           page: page,
                                           completion: completion)
    }

}
