//
//  LoadController.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 13.04.2021.
//

import UIKit

final class LoadController: UIViewController {

    init() {
        super.init(nibName: nil, bundle: nil)

        view.backgroundColor = .init(white: 0.0, alpha: 0.5)

        let box = UIView()

        let indicator = UIActivityIndicatorView(style: .large)
        indicator.startAnimating()

        box.backgroundColor = .systemBackground
        box.layer.cornerRadius = 12.0

        view.addSubview(box)
        box.addSubview(indicator)

        box.anchor(centerX: view.centerXAnchor, centerY: view.centerYAnchor, width: 100, height: 100)
        indicator.anchor(centerX: box.centerXAnchor, centerY: box.centerYAnchor)

        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
