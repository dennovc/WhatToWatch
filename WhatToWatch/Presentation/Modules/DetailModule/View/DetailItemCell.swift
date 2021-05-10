//
//  DetailItemCell.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 11.04.2021.
//

import UIKit

final class DetailItemCell: UICollectionViewCell {

    static let reuseIdentifier = String(describing: DetailItemCell.self)

    // MARK: - UI

    private let imageView = ImageView()

    private let titleLabel: UILabel = {
        let label = UILabel()

        label.adjustsFontForContentSizeCategory = true
        label.font = .preferredFont(forTextStyle: .body, weight: .bold)

        label.textColor = UIColor(named: "TextColor")
        label.numberOfLines = 0

        return label
    }()

    private let overviewLabel: UILabel = {
        let label = UILabel()

        label.adjustsFontForContentSizeCategory = true
        label.font = .preferredFont(forTextStyle: .subheadline)

        label.textColor = UIColor(named: "TextColor")
        label.numberOfLines = 0

        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()

        label.adjustsFontForContentSizeCategory = true
        label.font = .preferredFont(forTextStyle: .subheadline)

        label.textColor = UIColor(named: "TextColor")
        label.numberOfLines = 0

        return label
    }()

    private let ratingLabel = RatingLabel()

    private let dateLabel: UILabel = {
        let label = UILabel()

        label.adjustsFontForContentSizeCategory = true
        label.font = .preferredFont(forTextStyle: .subheadline)

        label.textColor = UIColor(named: "TextColor")

        return label
    }()

    private let countryLabel: UILabel = {
        let label = UILabel()

        label.adjustsFontForContentSizeCategory = true
        label.font = .preferredFont(forTextStyle: .footnote)

        label.textColor = UIColor(named: "SecondaryTextColor")
        label.numberOfLines = 0

        return label
    }()

    private let runtimeLabel: UILabel = {
        let label = UILabel()

        label.adjustsFontForContentSizeCategory = true
        label.font = .preferredFont(forTextStyle: .footnote)

        label.textColor = UIColor(named: "SecondaryTextColor")
        label.numberOfLines = 0

        return label
    }()

    // MARK: - Private Properties

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
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

    func fill(with viewModel: DetailItemViewModel, imageRepository: ImageRepository) {
        titleLabel.text = viewModel.title
        overviewLabel.text = viewModel.overview
        descriptionLabel.text = viewModel.description ?? "N/A"
        ratingLabel.value = viewModel.rating
        dateLabel.text = viewModel.date != nil ? dateFormatter.string(from: viewModel.date!) : "N/A"
        dateLabel.text = viewModel.rating != nil ? " · \(dateLabel.text!)" : dateLabel.text
        countryLabel.text = viewModel.country ?? "N/A"
        runtimeLabel.text = viewModel.runtime?.map { "\(Int($0 / 60)) min" }.joined(separator: ", ")
        imageView.updateImage(path: viewModel.imagePath, width: 350, repository: imageRepository)
    }

    // MARK: - Private Methods

    private func configureUI() {
        let rightStack = UIStackView(arrangedSubviews: [
            titleLabel,
            descriptionLabel,
            UIStackView(arrangedSubviews: [ratingLabel, dateLabel]),
            countryLabel,
            runtimeLabel
        ])
        rightStack.axis = .vertical
        rightStack.alignment = .leading
        rightStack.spacing = 15.0

        let topStack = UIStackView(arrangedSubviews: [imageView, rightStack])
        topStack.axis = .horizontal
        topStack.alignment = .top
        topStack.spacing = 15.0

        let mainStack = UIStackView(arrangedSubviews: [topStack, overviewLabel])
        mainStack.axis = .vertical
        mainStack.spacing = 20.0

        contentView.addSubview(mainStack)

        imageView.anchor(width: 150, height: 225)

        mainStack.anchor(top: contentView.topAnchor, left: contentView.leftAnchor)

        let bottomConstraint = mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        let rightConstraint = mainStack.rightAnchor.constraint(equalTo: contentView.rightAnchor)

        bottomConstraint.priority = .init(999)
        rightConstraint.priority = .init(999)

        bottomConstraint.isActive = true
        rightConstraint.isActive = true
    }

}
