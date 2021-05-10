//
//  ImageView.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 11.04.2021.
//

import UIKit

final class ImageView: UIImageView {

    // MARK: - Private Properties

    private let placeholder = UIImage(systemName: "film")
    private var imagePath: String?

    // MARK: - Properties

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

    // MARK: - Methods

    func updateImage(path: String?, width: Int, repository: ImageRepository) {
        imagePath = path
        image = nil

        guard let path = path else { return }

        repository.fetchImage(path: path, width: width) { [weak self] result in
            guard self?.imagePath == path else { return }

            if case let .success(data) = result {
                self?.image = UIImage(data: data)
            }
        }
    }

}
