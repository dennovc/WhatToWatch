//
//  MockCoordinator.swift
//  WhatToWatchTests
//
//  Created by Denis Novitsky on 05.03.2021.
//

@testable import WhatToWatch

final class MockCoordinator: CoordinatorProtocol {

    // MARK: - Properties

    private(set) var didStart = false

    // MARK: - Methods

    func start() {
        didStart = true
    }

}
