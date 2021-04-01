//
//  NetworkServiceProtocol.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 23.03.2021.
//

protocol NetworkServiceProtocol: class {

    func requestAndDecode<T: Decodable>(_ request: NetworkRequestProtocol,
                                        completion: @escaping (Result<T, NetworkError>) -> Void)

}

// MARK: - Network Error

enum NetworkError: Error {

    // MARK: - Cases

    case apiError
    case invalidEndpoint
    case invalidResponse
    case noData
    case serializationError

    // MARK: - Properties

    var localizedDescription: String {
        switch self {
        case .apiError: return "Failed to fetch data"
        case .invalidEndpoint: return "Invalid endpoint"
        case .invalidResponse: return "Invalid response"
        case .noData: return "No data"
        case .serializationError: return "Failed to decode data"
        }
    }

}
