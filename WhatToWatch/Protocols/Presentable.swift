//
//  Presentable.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 27.02.2021.
//

import UIKit

protocol Presentable: class {

    func toPresent() -> UIViewController?

}

// MARK: - View Controller Extension

extension UIViewController: Presentable {

    func toPresent() -> UIViewController? {
        return self
    }

}
