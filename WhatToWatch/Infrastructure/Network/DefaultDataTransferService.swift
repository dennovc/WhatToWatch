//
//  DefaultDataTransferService.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 18.04.2021.
//

import Foundation

final class DefaultDataTransferService {

    // MARK: - Private Properties

    private let networkService: NetworkService

    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    // MARK: - Private Methods

    private func decode<T: Decodable>(_ data: Data?, decoder: ResponseDecoder) -> Result<T, DataTransferError> {
        guard let data = data else { return .failure(.noResponse) }

        do {
            let result: T = try decoder.decode(data)
            return .success(result)
        } catch {
            return .failure(.parsing(error))
        }
    }

    private func executeCompletionHandlerInMainThread<T>(with result: Result<T, DataTransferError>,
                                                         completion: @escaping CompletionHandler<T>) {
        DispatchQueue.main.async { completion(result) }
    }

}

// MARK: - Data Transfer Service

extension DefaultDataTransferService: DataTransferService {

    func request<T: Decodable, E: ResponseRequestable>(
        with endpoint: E,
        completion: @escaping CompletionHandler<T>) -> Cancellable? where E.Response == T {
        return networkService.request(with: endpoint) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let data):
                let decodedResult: Result<T, DataTransferError> = self.decode(data,
                                                                              decoder: endpoint.responseDecoder)
                self.executeCompletionHandlerInMainThread(with: decodedResult, completion: completion)
            case .failure(let error):
                self.executeCompletionHandlerInMainThread(with: .failure(.networkFailure(error)),
                                                          completion: completion)
            }
        }
    }

}
