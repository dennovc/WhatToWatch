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

    func fetchMovieDetail(id: Int, completion: @escaping CompletionHandler<Movie>) -> Cancellable? {
        return mediaRepository.fetchMovie(id: id, completion: completion)
    }

    func fetchTVDetail(id: Int, completion: @escaping CompletionHandler<TV>) -> Cancellable? {
        return mediaRepository.fetchTV(id: id, completion: completion)
    }

    func fetchPersonDetail(id: Int, completion: @escaping CompletionHandler<Person>) -> Cancellable? {
        return mediaRepository.fetchPerson(id: id, completion: completion)
    }

}
