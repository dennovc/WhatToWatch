//
//  NetworkService.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 23.03.2021.
//

import Foundation

final class NetworkService1: NetworkServiceProtocol {

    // MARK: - Private Properties

    private let session: URLSessionProtocol1

    // MARK: - Life Cycle

    init(session: URLSessionProtocol1 = URLSession.shared) {
        self.session = session
    }

    // MARK: - Methods

    func request(_ networkRequest: NetworkRequestProtocol,
                 completion: @escaping (Result<Data, NetworkError1>) -> Void) {
        guard let url = getComponents(from: networkRequest).url else {
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

            self?.executeCompletionHandlerInMainThread(with: .success(data),
                                                       completion: completion)
        }.resume()
    }

    func requestAndDecode<T: Decodable>(_ networkRequest: NetworkRequestProtocol,
                                        completion: @escaping (Result<T, NetworkError1>) -> Void) {
        request(networkRequest) {
            switch $0 {
            case .success(let data):
                do {
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(decodedData))
                } catch {
                    completion(.failure(.serializationError))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
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

    private func executeCompletionHandlerInMainThread<T>(
        with result: Result<T, NetworkError1>,
        completion: @escaping (Result<T, NetworkError1>) -> Void) {
        DispatchQueue.main.async { completion(result) }
    }

}
