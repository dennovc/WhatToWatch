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

    private let dateLabel: NALabel = {
        let label = NALabel()

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

    func configure(with info: Movie, fetchImage: (String?, @escaping (UIImage?) -> Void) -> Void) {
        titleLabel.text = info.title
        dateLabel.text = info.releaseYear
        voteAverageLabel.rating = info.voteAverage
        posterView.image = nil
        id = info.id

        fetchImage(info.posterPath) { [weak self] in
            guard self?.id == info.id else { return }
            self?.posterView.image = $0
        }
    }

    func configure(with info: TV, fetchImage: (String?, @escaping (UIImage?) -> Void) -> Void) {
        titleLabel.text = info.title
        dateLabel.text = info.firstAirDate
        voteAverageLabel.rating = info.voteAverage
        posterView.image = nil
        id = info.id

        fetchImage(info.posterPath) { [weak self] in
            guard self?.id == info.id else { return }
            self?.posterView.image = $0
        }
    }

    func configure(with info: Person, fetchImage: (String?, @escaping (UIImage?) -> Void) -> Void) {
        titleLabel.text = info.name
        posterView.image = nil
        dateLabel.text = nil
        voteAverageLabel.rating = nil
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
                      right: nil,
                      bottom: bottomAnchor,
                      left: leftAnchor,
                      paddingTop: 15,
                      paddingRight: 0,
                      paddingBottom: 15,
                      paddingLeft: 20,
                      width: 100,
                      height: 150)

        stack.anchor(top: topAnchor,
                     right: rightAnchor,
                     bottom: nil,
                     left: posterView.rightAnchor,
                     paddingTop: 15,
                     paddingRight: 48,
                     paddingBottom: 0,
                     paddingLeft: 15)
    }

}
