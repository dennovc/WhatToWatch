//
//  MainDetailSectionCell.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 11.04.2021.
//

import UIKit

final class MainDetailSectionCell: UICollectionViewCell {

    static let reuseIdentifier = "main-detail-section-cell"

    // MARK: UI

    private let posterView = ImageView()

    private let titleLabel: UILabel = {
        let label = UILabel()

        label.font = .preferredFont(forTextStyle: .body, weight: .bold)
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0

        return label
    }()

    private let genreLabel: UILabel = {
        let label = UILabel()

        label.font = .preferredFont(forTextStyle: .subheadline)
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0

        return label
    }()

    private let ratingLabel = RatingLabel()

    private let yearLabel: UILabel = {
        let label = UILabel()

        label.font = .preferredFont(forTextStyle: .subheadline)
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 1

        return label
    }()

    private let countryLabel: UILabel = {
        let label = UILabel()

        label.font = .preferredFont(forTextStyle: .footnote)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .secondaryLabel
        label.numberOfLines = 1

        return label
    }()

    private let runtimeLabel: UILabel = {
        let label = UILabel()

        label.font = .preferredFont(forTextStyle: .footnote)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .secondaryLabel
        label.numberOfLines = 1

        return label
    }()

    private let overviewLabel: UILabel = {
        let label = UILabel()

        label.font = .preferredFont(forTextStyle: .subheadline)
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0

        return label
    }()

    func configure(with model: SearchResult, imageLoader: (String?, @escaping (UIImage?) -> Void) -> Void) {
        switch model {
        case .movie(let info): configure(with: info, imageLoader: imageLoader)
        case .tv(let info): configure(with: info, imageLoader: imageLoader)
        case .person(let info): configure(with: info, imageLoader: imageLoader)
        }
    }

    private func configure(with movie: Movie, imageLoader: (String?, @escaping (UIImage?) -> Void) -> Void) {
        titleLabel.text = movie.title
        genreLabel.text = movie.genres?.map(\.name).joined(separator: ", ")
        ratingLabel.rating = movie.voteAverage
        yearLabel.text = " · \(movie.releaseYear)"
        countryLabel.text = movie.countries?.map(\.name).joined(separator: ", ")
        overviewLabel.text = movie.overview

        if let runtime = movie.runtime {
            runtimeLabel.text = "\(runtime) min"
        }

        imageLoader(movie.posterPath) { [weak self] in
            self?.posterView.image = $0
        }
    }

    private func configure(with tv: TV, imageLoader: (String?, @escaping (UIImage?) -> Void) -> Void) {
        titleLabel.text = tv.title
        genreLabel.text = tv.genres?.map(\.name).joined(separator: ", ")
        ratingLabel.rating = tv.voteAverage
        yearLabel.text = " · \(tv.releaseYear)"
        countryLabel.text = tv.countries?.map(\.name).joined(separator: ", ")
        overviewLabel.text = tv.overview

        imageLoader(tv.posterPath) { [weak self] in
            self?.posterView.image = $0
        }
    }

    func configure(with person: Person, imageLoader: (String?, @escaping (UIImage?) -> Void) -> Void) {
        titleLabel.text = person.name
        yearLabel.text = person.birthday
        overviewLabel.text = person.biography

        imageLoader(person.pathToPhoto) { [weak self] in
            self?.posterView.image = $0
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        let ratingAndYearStackView = UIStackView(arrangedSubviews: [ratingLabel, yearLabel])
        ratingAndYearStackView.axis = .horizontal
        ratingAndYearStackView.alignment = .leading

        let stackView = UIStackView(arrangedSubviews: [titleLabel,
                                                       genreLabel,
                                                       ratingAndYearStackView,
                                                       countryLabel,
                                                       runtimeLabel])
        stackView.axis = .vertical
        stackView.spacing = 10

        contentView.addSubview(posterView)
        contentView.addSubview(stackView)
        contentView.addSubview(overviewLabel)

        posterView.anchor(top: contentView.topAnchor,
                          right: nil,
                          bottom: nil,
                          left: contentView.leftAnchor,
                          width: 150,
                          height: 225)

        stackView.anchor(top: contentView.topAnchor,
                         right: nil,
                         bottom: nil,
                         left: posterView.rightAnchor,
                         paddingLeft: 15)

        let titleLabelRightConstraint = titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor)
        titleLabelRightConstraint.priority = .init(999)
        titleLabelRightConstraint.isActive = true

        overviewLabel.anchor(top: posterView.bottomAnchor,
                             right: contentView.rightAnchor,
                             bottom: nil,
                             left: contentView.leftAnchor,
                             paddingTop: 15)

        let overviewLabelBottomConstraint = overviewLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        overviewLabelBottomConstraint.priority = .init(999)
        overviewLabelBottomConstraint.isActive = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
