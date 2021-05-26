//
//  DefaultNetworkSessionManager.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 20.04.2021.
//

import Foundation

final class DefaultNetworkSessionManager {

    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

}

// MARK: - Network Session Manager

extension DefaultNetworkSessionManager: NetworkSessionManager {

    func request(_ request: URLRequest, completion: @escaping CompletionHandler) -> Cancellable {
        let task = session.dataTask(with: request, completionHandler: completion)
        task.resume()

        return task
    }

}
