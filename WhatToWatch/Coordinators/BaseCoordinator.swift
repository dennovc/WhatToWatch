//
//  BaseCoordinator.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 02.03.2021.
//

class BaseCoordinator: CoordinatorProtocol {

    // MARK: - Private Properties

    private var childCoordinators = [CoordinatorProtocol]()

    // MARK: - Methods

    func start() {}

    func addDependency(_ coordinator: CoordinatorProtocol) {
        guard
            coordinator !== self,
            !childCoordinators.contains(where: { $0 === coordinator })
        else { return }

        childCoordinators.append(coordinator)
    }

    func removeDependency(_ coordinator: CoordinatorProtocol) {
        guard let indexOfCoordinator = childCoordinators.firstIndex(where: { $0 === coordinator }) else { return }

        removeAllDependencies(for: coordinator)
        childCoordinators.remove(at: indexOfCoordinator)
    }

    // MARK: - Private Methods

    private func removeAllDependencies(for coordinator: CoordinatorProtocol) {
        guard let coordinator = coordinator as? BaseCoordinator else { return }
        coordinator.childCoordinators.forEach { coordinator.removeDependency($0) }
    }

}
