//
//  BaseFlowCoordinator.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 02.03.2021.
//

import Foundation

class BaseFlowCoordinator: FlowCoordinator {

    // MARK: - Private Properties

    private var childCoordinators = [FlowCoordinator]()

    // MARK: - Methods

    func addDependency(_ coordinator: FlowCoordinator) {
        guard
            coordinator !== self,
            !childCoordinators.contains(where: { $0 === coordinator })
        else { return }

        childCoordinators.append(coordinator)
    }

    func removeDependency(_ coordinator: FlowCoordinator?) {
        guard
            !childCoordinators.isEmpty,
            let coordinator = coordinator,
            let coordinatorIndex = childCoordinators.firstIndex(where: { $0 === coordinator })
        else { return }

        removeAllDependencies(for: coordinator)
        childCoordinators.remove(at: coordinatorIndex)
    }

    func start() {
        preconditionFailure("This method is abstract. Should be overriden")
    }

    // MARK: - Private Methods

    private func removeAllDependencies(for coordinator: FlowCoordinator) {
        guard let coordinator = coordinator as? BaseFlowCoordinator else { return }
        coordinator.childCoordinators.forEach(coordinator.removeDependency)
    }

}
