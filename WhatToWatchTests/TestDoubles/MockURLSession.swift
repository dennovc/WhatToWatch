//
//  MockURLSession.swift
//  WhatToWatchTests
//
//  Created by Denis Novitsky on 01.04.2021.
//

import Foundation
@testable import WhatToWatch

final class MockURLSession: URLSessionProtocol {

    // MARK: - Properties

    let dataTask = MockURLSessionDataTask()
    private(set) var receivedURL: URL?
    private(set) var receivedCompletion: ((Data?, URLResponse?, Error?) -> Void)?

    // MARK: - Methods

    func dataTask(with url: URL,
                  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        receivedURL = url
        receivedCompletion = completionHandler

        return dataTask
    }

}

// MARK: - Mock URL Session Data Task

final class MockURLSessionDataTask: URLSessionDataTask {

    // MARK: - Properties

    private(set) var didResume = false

    // MARK: - Life Cycle

    override init() {}

    // MARK: - Methods

    override func resume() {
        didResume = true
    }

}
