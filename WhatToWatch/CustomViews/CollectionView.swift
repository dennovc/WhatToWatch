//
//  CollectionView.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 11.04.2021.
//

import UIKit

final class CollectionView: UICollectionView {

    // Fix bug iOS 14.3+
    override func layoutSubviews() {
        super.layoutSubviews()

        guard #available(iOS 14.3, *) else { return }

        subviews.forEach { subview in
            guard
                let scrollView = subview as? UIScrollView,
                let minY = scrollView.subviews.map(\.frame.origin.y).min(),
                minY > scrollView.frame.minY
            else { return }

            scrollView.contentInset.top = -minY
            scrollView.frame.origin.y = minY
        }
    }

}
