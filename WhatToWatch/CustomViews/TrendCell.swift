//
//  TrendCell.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 13.04.2021.
//

import UIKit

final class TrendCell: UICollectionViewCell {

    static let reuseIdentifier = "cast-detail-section-cell"

    private let imageView = ImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(imageView)

        imageView.anchor(top: contentView.topAnchor,
                         right: contentView.rightAnchor,
                         bottom: contentView.bottomAnchor,
                         left: contentView.leftAnchor)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with model: SearchResult, imageLoader: (String?, @escaping (UIImage?) -> Void) -> Void) {
        switch model {
        case .movie(let info): configure(with: info, imageLoader: imageLoader)
        case .tv(let info): configure(with: info, imageLoader: imageLoader)
        case .person: break
        }
    }

    private func configure(with movie: Movie1, imageLoader: (String?, @escaping (UIImage?) -> Void) -> Void) {
        imageLoader(movie.posterPath) { [weak self] in
            self?.imageView.image = $0
        }
    }

    private func configure(with tv: TV1, imageLoader: (String?, @escaping (UIImage?) -> Void) -> Void) {
        imageLoader(tv.posterPath) { [weak self] in
            self?.imageView.image = $0
        }
    }
    
}
