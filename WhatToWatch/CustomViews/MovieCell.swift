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

    private var poster: UIImage? {
        didSet {
            guard let poster = poster else {
                posterView.image = UIImage(systemName: "film")
                return
            }
            posterView.image = poster
        }
    }

    private var title: String? {
        didSet {
            titleLabel.text = title
        }
    }

    private var voteAverage: Double? {
        didSet {
            guard let voteAverage = voteAverage else {
                voteAverageLabel.text = nil
                return
            }

            voteAverageLabel.text = "★ \(voteAverage)"

            switch voteAverage {
            case 7.0...10.0: voteAverageLabel.textColor = .systemGreen
            case 0.1..<5.0: voteAverageLabel.textColor = .systemRed
            default: voteAverageLabel.textColor = .secondaryLabel
            }
        }
    }

    private var date: String? {
        didSet {
            guard
                let date = date,
                let formattedDate = Utils.dateFormatter.date(from: date)
            else {
                dateLabel.text = "N/A · "
                return
            }

            let year = Utils.yearFormatter.string(from: formattedDate)
            dateLabel.text = "\(year)"
        }
    }

    // MARK: - UI

    private var posterView: UIImageView = {
        let image = UIImageView()

        image.backgroundColor = .secondarySystemBackground
        image.contentMode = .scaleAspectFit
        image.tintColor = .systemGray

        return image
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()

        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 3

        return label
    }()

    private let voteAverageLabel: UILabel = {
        let label = UILabel()

        label.font = UIFont.preferredFont(forTextStyle: .footnote, weight: .bold)
        label.adjustsFontForContentSizeCategory = true

        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()

        label.font = UIFont.preferredFont(forTextStyle: .footnote)
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
        title = info.title
        date = info.releaseDate
        voteAverage = info.voteAverage
        poster = nil
        id = info.id

        fetchImage(info.posterPath) { [weak self] in
            guard self?.id == info.id else { return }
            self?.poster = $0
        }
    }

    func configure(with info: TV, fetchImage: (String?, @escaping (UIImage?) -> Void) -> Void) {
        title = info.title
        date = info.firstAirDate
        voteAverage = info.voteAverage
        poster = nil
        id = info.id

        fetchImage(info.posterPath) { [weak self] in
            guard self?.id == info.id else { return }
            self?.poster = $0
        }
    }

    func configure(with info: Person, fetchImage: (String?, @escaping (UIImage?) -> Void) -> Void) {
        title = info.name
        poster = nil
        dateLabel.text = nil
        voteAverage = nil
        id = info.id
        fetchImage(info.pathToPhoto) { [weak self] in
            guard self?.id == info.id else { return }
            self?.poster = $0
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
