//
//  SearchItemCell.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 04.04.2021.
//

import UIKit

final class SearchItemCell: UITableViewCell {

    static let reuseIdentifier = String(describing: SearchItemCell.self)

    // MARK: - UI

    private let posterView = ImageView()

    private let titleLabel: UILabel = {
        let label = UILabel()

        label.adjustsFontForContentSizeCategory = true
        label.font = .preferredFont(forTextStyle: .headline, weight: .medium)

        label.textColor = UIColor(named: "TextColor")
        label.numberOfLines = 3

        return label
    }()

    private let ratingLabel = RatingLabel()

    private let dateLabel: UILabel = {
        let label = UILabel()

        label.adjustsFontForContentSizeCategory = true
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = UIColor(named: "SecondaryTextColor")

        return label
    }()

    // MARK: - Private Properties

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()

    // MARK: - Initialization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    func fill(with viewModel: SearchItemViewModel, imageRepository: ImageRepository) {
        titleLabel.text = viewModel.title
        ratingLabel.value = viewModel.rating
        dateLabel.text = viewModel.date != nil ? dateFormatter.string(from: viewModel.date!) : nil
        posterView.updateImage(path: viewModel.imagePath, width: 350, repository: imageRepository)
    }

    // MARK: - Private Methods

    private func configureUI() {
        selectionStyle = .none
        accessoryType = .disclosureIndicator

        let rightStack = UIStackView(arrangedSubviews: [
            titleLabel, ratingLabel, dateLabel
        ])
        rightStack.axis = .vertical
        rightStack.spacing = 15

        let mainStack = UIStackView(arrangedSubviews: [
            posterView, rightStack
        ])
        mainStack.axis = .horizontal
        mainStack.alignment = .top
        mainStack.spacing = 15

        contentView.addSubview(mainStack)

        posterView.anchor(width: 100, height: 150)

        mainStack.anchor(top: contentView.topAnchor,
                         left: contentView.leftAnchor,
                         bottom: contentView.bottomAnchor,
                         right: contentView.rightAnchor,
                         paddingTop: 15,
                         paddingLeft: 20,
                         paddingBottom: 15,
                         paddingRight: 50)
    }

}
