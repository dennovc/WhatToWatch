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

    func searchMovie(query: String, page: Int, completion: @escaping CompletionHandler) -> Cancellable? {
        return mediaRepository.fetchMoviesList(query: query, page: page, completion: completion)
    }

    func searchTV(query: String, page: Int, completion: @escaping CompletionHandler) -> Cancellable? {
        return mediaRepository.fetchTVList(query: query, page: page, completion: completion)
    }

    func searchPerson(query: String, page: Int, completion: @escaping CompletionHandler) -> Cancellable? {
        return mediaRepository.fetchPersonsList(query: query, page: page, completion: completion)
    }

}
