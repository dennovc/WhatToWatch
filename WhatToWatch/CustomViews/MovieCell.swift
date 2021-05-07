//
//  MovieCell.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 04.04.2021.
//

import UIKit

final class MovieCell: UITableViewCell {

    // MARK: - Static Properties

    static let identifier = "MovieCell"

    // MARK: - Privete Properties

    private var id: Int?

    // MARK: - UI

    private var posterView = ImageView()

    private let titleLabel: UILabel = {
        let label = UILabel()

        label.font = UIFont.preferredFont(forTextStyle: .headline, weight: .medium)
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 3

        return label
    }()

    private let voteAverageLabel = RatingLabel()

    private let dateLabel: UILabel = {
        let label = UILabel()

        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .secondaryLabel
        label.numberOfLines = 1

        return label
    }()

    // MARK: - Life Cycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    func configure(with info: Movie1, fetchImage: (String?, @escaping (UIImage?) -> Void) -> Void) {
        titleLabel.text = info.title
        dateLabel.text = info.releaseYear
        voteAverageLabel.value = info.voteAverage
        posterView.image = nil
        id = info.id

        fetchImage(info.posterPath) { [weak self] in
            guard self?.id == info.id else { return }
            self?.posterView.image = $0
        }
    }

    func configure(with info: TV1, fetchImage: (String?, @escaping (UIImage?) -> Void) -> Void) {
        titleLabel.text = info.title
        dateLabel.text = info.firstAirDate
        voteAverageLabel.value = info.voteAverage
        posterView.image = nil
        id = info.id

        fetchImage(info.posterPath) { [weak self] in
            guard self?.id == info.id else { return }
            self?.posterView.image = $0
        }
    }

    func configure(with info: Person1, fetchImage: (String?, @escaping (UIImage?) -> Void) -> Void) {
        titleLabel.text = info.name
        posterView.image = nil
        dateLabel.text = nil
        voteAverageLabel.value = nil
        id = info.id
        fetchImage(info.pathToPhoto) { [weak self] in
            guard self?.id == info.id else { return }
            self?.posterView.image = $0
        }
    }

    // MARK: - Configure UI

    private func configureUI() {
        accessoryType = .disclosureIndicator

        let stack = UIStackView(arrangedSubviews: [titleLabel, voteAverageLabel, dateLabel])
        stack.axis = .vertical
        stack.spacing = 15

        addSubview(posterView)
        addSubview(stack)

        posterView.anchor(top: topAnchor,
                          left: leftAnchor,
                          bottom: bottomAnchor,
                      right: nil,
                      paddingTop: 15,
                      paddingLeft: 20,
                      paddingBottom: 15,
                      paddingRight: 0,
                      width: 100,
                      height: 150)

        stack.anchor(top: topAnchor,
                     left: posterView.rightAnchor,
                     bottom: nil,
                     right: rightAnchor,
                     paddingTop: 15,
                     paddingLeft: 15,
                     paddingBottom: 0,
                     paddingRight: 48)
    }

}
