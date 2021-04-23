//
//  DefaultImageRepository.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 23.04.2021.
//

import Foundation

final class DefaultImageRepository {

    private let dataTransferService: DataTransferService
    private var imageCache: AnyCacheService<String, Data>

    init<ImageCache: CacheService>(dataTransferService: DataTransferService,
                                   imageCache: ImageCache) where ImageCache.Key == String,
                                                                 ImageCache.Value == Data {
        self.dataTransferService = dataTransferService
        self.imageCache = AnyCacheService(imageCache)
    }

}

// MARK: - Image Repository

extension DefaultImageRepository: ImageRepository {

    func fetchImage(path: String, width: Int, completion: @escaping CompletionHandler) -> Cancellable? {
        if let imageData = imageCache[path] {
            completion(.success(imageData))
            return nil
        }

        let endpoint = APIEndpoints.fetchMediaImage(path: path, width: width)

        return dataTransferService.request(with: endpoint) { [weak self] result in
            if case .success(let imageData) = result {
                self?.imageCache[path] = imageData
            }
            completion(result.mapError { $0 as Error } )
        }
    }

}
