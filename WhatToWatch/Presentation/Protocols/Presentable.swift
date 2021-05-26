//
//  Presentable.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 27.02.2021.
//

import UIKit

/// We can create a module as complicated as we want, but it is necessary to extract `UIViewController` for the router's usage.
protocol Presentable {

    /**
     Extract `UIViewController` for the router's usage.

     - Returns: extracted `UIViewController` or `nil`.
     */
    func toPresent() -> UIViewController?

}

// MARK: - View Controller Extension

extension UIViewController: Presentable {

    func toPresent() -> UIViewController? { self }

}
