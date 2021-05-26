//
//  DetailCastCell.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 11.04.2021.
//

import UIKit

final class DetailCastCell: UICollectionViewCell {

    static let reuseIdentifier = String(describing: DetailCastCell.self)

    // MARK: - UI

    private let imageView: ImageView = {
        let imageView = ImageView()

        imageView.layer.shadowRadius = 5.0
        imageView.layer.shadowOpacity = 0.7
        imageView.layer.shadowOffset = .init(width: 2.5, height: 2.5)

        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()

        label.adjustsFontForContentSizeCategory = true
        label.font = .preferredFont(forTextStyle: .caption1)

        label.textColor = UIColor(named: "TextColor")
        label.numberOfLines = 1

        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()

        label.adjustsFontForContentSizeCategory = true
        label.font = .preferredFont(forTextStyle: .caption2)

        label.textColor = UIColor(named: "SecondaryTextColor")
        label.numberOfLines = 1

        return label
    }()

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    func fill(with viewModel: DetailCastViewModel, imageRepository: ImageRepository) {
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
        imageView.updateImage(path: viewModel.imagePath, width: 350, repository: imageRepository)
    }

    // MARK: - Private Methods

    private func configureUI() {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])
        stackView.axis = .vertical

        contentView.addSubview(imageView)
        contentView.addSubview(stackView)

        imageView.anchor(top: contentView.topAnchor,
                         left: contentView.leftAnchor,
                         width: 100, height: 150)

        stackView.anchor(top: imageView.bottomAnchor,
                         left: contentView.leftAnchor,
                         right: contentView.rightAnchor,
                         paddingTop: 4.0)
        let bottomConstraint = stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        bottomConstraint.priority = .init(999)
        bottomConstraint.isActive = true
    }

}
