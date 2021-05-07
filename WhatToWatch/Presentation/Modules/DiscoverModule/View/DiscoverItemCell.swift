//
//  DiscoverItemCell.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 13.04.2021.
//

import UIKit

final class DiscoverItemCell: UICollectionViewCell {

    static let reuseIdentifier = String(describing: DiscoverItemCell.self)

    // MARK: - UI

    private let imageView: ImageView = {
        let imageView = ImageView()

        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12.0

        return imageView
    }()

    // MARK: - Private Properties

    private var viewModel: DiscoverItemViewModel!
    private var imageRepository: ImageRepository!

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    func fill(with viewModel: DiscoverItemViewModel, imageRepository: ImageRepository) {
        self.viewModel = viewModel
        self.imageRepository = imageRepository

        updateImage(width: 350)
    }

    // MARK: - Private Methods

    private func configureUI() {
        contentView.addSubview(imageView)

        imageView.anchor(top: contentView.topAnchor,
                         left: contentView.leftAnchor,
                         bottom: contentView.bottomAnchor,
                         right: contentView.rightAnchor)
    }

    private func updateImage(width: Int) {
        imageView.image = nil

        guard let imagePath = viewModel.imagePath else { return }

        imageRepository.fetchImage(path: imagePath, width: width) { [weak self] result in
            guard self?.viewModel.imagePath == imagePath else { return }

            if case let .success(data) = result {
                self?.imageView.image = UIImage(data: data)
            }
        }
    }

}
