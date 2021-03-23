//
//  NetworkManager.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 23.03.2021.
//

import Foundation

final class NetworkManager: NetworkManagerProtocol {

    // MARK: - Private Properties

    private let session: URLSessionProtocol

    // MARK: - Life Cycle

    init(session: URLSessionProtocol = URLSession(configuration: .default)) {
        self.session = session
    }

    // MARK: - Methods

    func request(router: NetworkRouterProtocol, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = getComponents(from: router).url else { return }

        session.dataTask(with: url) { data, _, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                } else if let data = data {
                    completion(.success(data))
                }
            }
        }.resume()
    }

    // MARK: - Private Methods

    private func getComponents(from router: NetworkRouterProtocol) -> URLComponents {
        var components = URLComponents()

        components.scheme = router.scheme
        components.host = router.host
        components.path = router.path
        components.queryItems = router.parameters

        return components
    }

}
