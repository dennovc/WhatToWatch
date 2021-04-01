//
//  NetworkService.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 23.03.2021.
//

import Foundation

final class NetworkService: NetworkServiceProtocol {

    // MARK: - Private Properties

    private let session: URLSessionProtocol

    // MARK: - Life Cycle

    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }

    // MARK: - Methods

    func requestAndDecode<T: Decodable>(_ request: NetworkRequestProtocol,
                                        completion: @escaping (Result<T, NetworkError>) -> Void) {
        guard let url = getComponents(from: request).url else {
            completion(.failure(.invalidEndpoint))
            return
        }

        session.dataTask(with: url) { [weak self] data, response, error in
            guard error == nil else {
                self?.executeCompletionHandlerInMainThread(with: .failure(.apiError),
                                                           completion: completion)
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  200..<300 ~= httpResponse.statusCode
            else {
                self?.executeCompletionHandlerInMainThread(with: .failure(.invalidResponse),
                                                           completion: completion)
                return
            }

            guard let data = data else {
                self?.executeCompletionHandlerInMainThread(with: .failure(.noData),
                                                           completion: completion)
                return
            }

            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                self?.executeCompletionHandlerInMainThread(with: .success(decodedData),
                                                           completion: completion)
            } catch {
                self?.executeCompletionHandlerInMainThread(with: .failure(.serializationError),
                                                           completion: completion)
            }
        }.resume()
    }

    // MARK: - Private Methods

    private func getComponents(from request: NetworkRequestProtocol) -> URLComponents {
        var components = URLComponents()

        components.scheme = request.scheme
        components.host = request.host
        components.path = request.path
        components.queryItems = request.parameters.map { URLQueryItem(name: $0.key, value: $0.value) }

        return components
    }

    private func executeCompletionHandlerInMainThread<T: Decodable>(
        with result: Result<T, NetworkError>,
        completion: @escaping (Result<T, NetworkError>) -> Void) {
        DispatchQueue.main.async { completion(result) }
    }

}
