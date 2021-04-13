//
//  ImageView.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 11.04.2021.
//

import UIKit

final class ImageView: UIImageView {

    override var image: UIImage? {
        get { super.image }
        set { super.image = newValue ?? UIImage(systemName: "film") }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentMode = .scaleAspectFit
        backgroundColor = .secondarySystemBackground
        tintColor = .systemGray

        image = UIImage(systemName: "film")
    }

    convenience init() {
        self.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
