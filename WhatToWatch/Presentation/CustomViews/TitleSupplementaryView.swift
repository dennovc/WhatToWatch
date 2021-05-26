//
//  TitleSupplementaryView.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 05.05.2021.
//

import UIKit

final class TitleSupplementaryView: UICollectionReusableView {

    static let reuseIdentifier = String(describing: TitleSupplementaryView.self)

    // MARK: - UI

    private let label: UILabel = {
        let label = UILabel()

        label.adjustsFontForContentSizeCategory = true
        label.font = .preferredFont(forTextStyle: .title1, weight: .bold)

        label.textColor = UIColor(named: "TextColor")
        label.numberOfLines = 0

        return label
    }()

    // MARK: - Properties

    var title: String? {
        get { label.text }
        set { label.text = newValue }
    }

    var font: UIFont {
        get { label.font }
        set { label.font = newValue }
    }

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Methods

    private func configureUI() {
        addSubview(label)

        label.anchor(top: topAnchor,
                     left: leftAnchor,
                     bottom: bottomAnchor,
                     right: rightAnchor)
    }

}
