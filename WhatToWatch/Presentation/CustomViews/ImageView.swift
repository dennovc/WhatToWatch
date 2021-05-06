//
//  ImageView.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 11.04.2021.
//

import UIKit

final class ImageView: UIImageView {

    // MARK: - Properties

    private let placeholder = UIImage(systemName: "film")

    override var image: UIImage? {
        get { super.image }
        set {
            super.image = newValue ?? placeholder
            contentMode = newValue == nil ? .scaleAspectFit : .scaleAspectFill
        }
    }

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)

        image = placeholder

        backgroundColor = UIColor(named: "SecondaryBackgroundColor")
        tintColor = .systemGray
    }

    convenience init() {
        self.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
