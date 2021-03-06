//
//  RatingLabel.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 11.04.2021.
//

import UIKit

final class RatingLabel: UILabel {

    var value: Double? {
        get {
            guard let value = text else { return nil }
            return Double(value)
        }
        set {
            guard let newValue = newValue else {
                text = nil
                return
            }

            text = "★ \(newValue)"

            switch newValue {
            case 7.0...10.0: textColor = .systemGreen
            case 0.1..<5.0: textColor = .systemRed
            default: textColor = UIColor(named: "SecondaryTextColor")
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        adjustsFontForContentSizeCategory = true
        font = .preferredFont(forTextStyle: .subheadline)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
