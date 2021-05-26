//
//  DefaultMediaDetailUseCase.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 22.04.2021.
//

import Foundation

final class DefaultMediaDetailUseCase {

    private let mediaRepository: MediaRepository

    init(mediaRepository: MediaRepository) {
        self.mediaRepository = mediaRepository
    }

}

// MARK: - Media Detail Use Case

extension DefaultMediaDetailUseCase: MediaDetailUseCase {

    func fetchMediaDetail(type: MediaType,
                          id: Int,
                          completion: @escaping CompletionHandler) -> Cancellable? {
        return mediaRepository.fetchMedia(type: type,
                                          id: id,
                                          completion: completion)
    }

}
