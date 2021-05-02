//
//  DefaultMediaRepository.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 23.04.2021.
//

import Foundation

struct MediaRepositoryCacheKey: Hashable {

    let type: MediaType
    let id: Int

}

final class DefaultMediaRepository {

    private let dataTransferService: DataTransferService
    private var cacheService: AnyCacheService<MediaRepositoryCacheKey, Media>

    init<T: CacheService>(dataTransferService: DataTransferService,
                          cacheService: T) where T.Key == MediaRepositoryCacheKey,
                                                 T.Value == Media {
        self.dataTransferService = dataTransferService
        self.cacheService = AnyCacheService(cacheService)
    }

    // MARK: - Private Methods

    private func request<T: Mappable & Decodable,
                         E: ResponseRequestable>(with endpoint: E,
                                                 completion: @escaping CompletionHandler<T.Result>) -> Cancellable?
                                                 where T == E.Response {
        return dataTransferService.request(with: endpoint) { result in
            switch result {
            case .success(let dataTransferObject): completion(.success(dataTransferObject.toDomain()))
            case .failure(let error): completion(.failure(error))
            }
        }
    }

}

// MARK: - Media Repository

extension DefaultMediaRepository: MediaRepository {

    func fetchMediaList(type: MediaType,
                        query: String,
                        page: Int,
                        completion: @escaping CompletionHandler<MediaPage>) -> Cancellable? {
        let endpoint = APIEndpoints.fetchMediaList(type: type, query: query, page: page)
        return request(with: endpoint, completion: completion)
    }

    func fetchMedia(type: MediaType,
                    id: Int,
                    completion: @escaping CompletionHandler<Media>) -> Cancellable? {
        let cacheKey = MediaRepositoryCacheKey(type: type, id: id)

        if let media = cacheService[cacheKey] {
            completion(.success(media))
            return nil
        }

        let endpoint = APIEndpoints.fetchMedia(type: type, id: id)

        return request(with: endpoint) { [weak self] result in
            if case .success(let media) = result {
                self?.cacheService[cacheKey] = media
            }
            completion(result)
        }
    }

}
