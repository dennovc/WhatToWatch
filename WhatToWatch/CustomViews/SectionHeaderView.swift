//
//  SectionHeaderView.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 12.04.2021.
//

import UIKit

final class SectionHeaderView: UICollectionReusableView {

    static let reuseIdentifier = "section-header-view"

    private let titleLabel: UILabel = {
        let label = UILabel()

        label.font = .preferredFont(forTextStyle: .title1, weight: .bold)
        label.adjustsFontForContentSizeCategory = true

        return label
    }()

    var title: String? {
        get { titleLabel.text }
        set { titleLabel.text = newValue }
    }

    var font: UIFont {
        get { titleLabel.font }
        set { titleLabel.font = newValue }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(titleLabel)

        titleLabel.anchor(top: topAnchor,
                          left: leftAnchor,
                          bottom: bottomAnchor,
                          right: rightAnchor)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
