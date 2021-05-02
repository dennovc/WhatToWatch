//
//  DefaultSearchMediaUseCase.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 22.04.2021.
//

import Foundation

final class DefaultSearchMediaUseCase {

    private let mediaRepository: MediaRepository

    init(mediaRepository: MediaRepository) {
        self.mediaRepository = mediaRepository
    }

}

// MARK: - Search Media Use Case

extension DefaultSearchMediaUseCase: SearchMediaUseCase {

    func searchMedia(type: MediaType,
                     query: String,
                     page: Int,
                     completion: @escaping CompletionHandler) -> Cancellable? {
        return mediaRepository.fetchMediaList(type: type,
                                              query: query,
                                              page: page,
                                              completion: completion)
    }

}
