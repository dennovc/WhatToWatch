//
//  CastDetailSectionCell.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 11.04.2021.
//

import UIKit

final class CastDetailSectionCell: UICollectionViewCell {

    static let reuseIdentifier = "cast-detail-section-cell"

    private var id: Int?

    // MARK: UI

    private let photoView: ImageView = {
        let imageView = ImageView()

        imageView.layer.shadowRadius = 7.0
        imageView.layer.shadowOpacity = 0.7
        imageView.layer.shadowOffset = .init(width: 2.5, height: 2.5)

        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()

        label.font = .preferredFont(forTextStyle: .caption1)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .label
        label.numberOfLines = 1

        return label
    }()

    private let characterLabel: UILabel = {
        let label = UILabel()

        label.font = .preferredFont(forTextStyle: .caption2)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .secondaryLabel
        label.numberOfLines = 1

        return label
    }()

    func configure(with cast: Cast1, imageLoader: (String?, @escaping (UIImage?) -> Void) -> Void) {
        id = cast.id
        nameLabel.text = cast.name
        characterLabel.text = cast.character
        photoView.image = nil

        imageLoader(cast.pathToPhoto) { [weak self] in
            guard self?.id == cast.id else { return }
            self?.photoView.image = $0
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        let stackView = UIStackView(arrangedSubviews: [nameLabel, characterLabel])
        stackView.axis = .vertical

        contentView.addSubview(photoView)
        contentView.addSubview(stackView)

        photoView.anchor(top: topAnchor,
                         left: leftAnchor,
                         width: 100,
                         height: 150)

        stackView.anchor(top: photoView.bottomAnchor,
                         left: contentView.leftAnchor,
                         right: contentView.rightAnchor)

        let stackViewBottomConstraint = stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        stackViewBottomConstraint.priority = .init(999)
        stackViewBottomConstraint.isActive = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
