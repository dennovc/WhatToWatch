//
//  FlowCoordinator.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 02.03.2021.
//

import Foundation

/// An object that handles navigation flow and shares flow's handling for the next coordinator after switching in the next chain.
protocol FlowCoordinator: AnyObject {

    /// Starts the coordinator.
    func start()

}
