//
//  UIFont+Extension.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 04.04.2021.
//

import UIKit

extension UIFont {

    static func preferredFont(forTextStyle style: TextStyle, weight: Weight) -> UIFont {
        let metrics = UIFontMetrics(forTextStyle: style)
        let descriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: style)
        let font = UIFont.systemFont(ofSize: descriptor.pointSize, weight: weight)

        return metrics.scaledFont(for: font)
    }

}
