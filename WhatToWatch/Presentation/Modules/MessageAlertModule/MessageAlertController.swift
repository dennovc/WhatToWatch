//
//  MessageAlertController.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 14.04.2021.
//

import UIKit

final class MessageAlertController {

    private let alertController: UIAlertController

    init(title: String?, message: String?) {
        alertController = .init(title: title, message: message, preferredStyle: .alert)

        let okAction = UIAlertAction(title: "OK", style: .default)

        alertController.addAction(okAction)
    }

}

// MARK: - Presentable

extension MessageAlertController: Presentable {

    func toPresent() -> UIViewController? {
        return alertController
    }

}
