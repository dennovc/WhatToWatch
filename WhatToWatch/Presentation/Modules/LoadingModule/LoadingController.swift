//
//  LoadingController.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 13.04.2021.
//

import UIKit

final class LoadingController: UIViewController {

    // MARK: - UI

    private let box: UIView = {
        let box = UIView()

        box.backgroundColor = UIColor(named: "SecondaryBackgroundColor")
        box.layer.cornerRadius = 12.0

        return box
    }()

    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)

        spinner.startAnimating()

        return spinner
    }()

    // MARK: - Initialization

    init() {
        super.init(nibName: nil, bundle: nil)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Methods

    private func configureUI() {
        view.backgroundColor = .init(white: 0.0, alpha: 0.5)
        modalPresentationStyle = .overFullScreen

        view.addSubview(box)
        box.anchor(centerX: view.centerXAnchor, centerY: view.centerYAnchor, width: 100, height: 100)

        box.addSubview(spinner)
        spinner.anchor(centerX: box.centerXAnchor, centerY: box.centerYAnchor)
    }

}
