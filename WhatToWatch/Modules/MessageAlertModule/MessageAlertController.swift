//
//  MessageAlertController.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 14.04.2021.
//

import UIKit

final class MessageAlertController: Presentable {

    private let alertController: UIAlertController

    init(title: String?, message: String?) {
        alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let okAction = UIAlertAction(title: "OK", style: .default)

        alertController.addAction(okAction)
    }

    func toPresent() -> UIViewController? {
        return alertController
    }

}
