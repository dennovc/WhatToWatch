//
//  DefaultNetworkService.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 18.04.2021.
//

import Foundation

final class DefaultNetworkService {

    // MARK: - Private Properties

    private let config: NetworkConfigurable
    private let sessionManager: NetworkSessionManager

    init(config: NetworkConfigurable, sessionManager: NetworkSessionManager = DefaultNetworkSessionManager()) {
        self.config = config
        self.sessionManager = sessionManager
    }

    // MARK: - Private Methods

    private func request(_ request: URLRequest, completion: @escaping CompletionHandler) -> Cancellable {
        return sessionManager.request(request) { [weak self] data, response, requestError in
            guard let self = self else { return }

            if let requestError = requestError {
                var error: NetworkError

                if let response = response as? HTTPURLResponse {
                    error = .error(statusCode: response.statusCode, data: data)
                } else {
                    error = self.resolve(error: requestError)
                }

                completion(.failure(error))
            } else {
                completion(.success(data))
            }
        }
    }

    private func resolve(error: Error) -> NetworkError {
        let code = URLError.Code(rawValue: (error as NSError).code)

        switch code {
        case .notConnectedToInternet: return .notConnected
        case .cancelled: return .cancelled
        default: return .generic(error)
        }
    }

}

// MARK: - Network Service

extension DefaultNetworkService: NetworkService {

    func request(with endpoint: Requestable, completion: @escaping CompletionHandler) -> Cancellable? {
        do {
            let urlRequest = try endpoint.urlRequest(with: config)
            return request(urlRequest, completion: completion)
        } catch {
            completion(.failure(.urlGeneration))
            return nil
        }
    }

}
