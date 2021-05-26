//
//  DefaultImageRepository.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 23.04.2021.
//

import Foundation

final class DefaultImageRepository {

    private let dataTransferService: DataTransferService
    private var cacheService: AnyCacheService<String, Data>

    init<T: CacheService>(dataTransferService: DataTransferService,
                          cacheService: T) where T.Key == String,
                                                 T.Value == Data {
        self.dataTransferService = dataTransferService
        self.cacheService = AnyCacheService(cacheService)
    }

}

// MARK: - Image Repository

extension DefaultImageRepository: ImageRepository {

    func fetchImage(path: String, width: Int, completion: @escaping CompletionHandler) -> Cancellable? {
        if let imageData = cacheService[path] {
            completion(.success(imageData))
            return nil
        }

        let endpoint = APIEndpoints.fetchMediaImage(path: path, width: width)

        return dataTransferService.request(with: endpoint) { [weak self] result in
            if case .success(let imageData) = result {
                self?.cacheService[path] = imageData
            }
            completion(result.mapError { $0 as Error })
        }
    }

}
