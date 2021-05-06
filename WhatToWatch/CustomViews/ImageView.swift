//
//  ImageView.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 11.04.2021.
//

import UIKit

final class ImageView: UIImageView {

    private var tempContentMode: ContentMode = .scaleAspectFit

    override var image: UIImage? {
        get {
            super.image
        }
        set {
            super.image = newValue ?? UIImage(systemName: "film")

            if newValue == nil {
                contentMode = .scaleAspectFit
            } else {
                contentMode = .scaleAspectFill
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

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
