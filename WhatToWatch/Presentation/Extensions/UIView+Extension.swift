//
//  UIView+Extension.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 04.04.2021.
//

import UIKit

extension UIView {

    func anchor(top: NSLayoutYAxisAnchor? = nil,
                left: NSLayoutXAxisAnchor? = nil,
                bottom: NSLayoutYAxisAnchor? = nil,
                right: NSLayoutXAxisAnchor? = nil,
                centerX: NSLayoutXAxisAnchor? = nil,
                centerY: NSLayoutYAxisAnchor? = nil,
                paddingTop: CGFloat = 0.0,
                paddingLeft: CGFloat = 0.0,
                paddingBottom: CGFloat = 0.0,
                paddingRight: CGFloat = 0.0,
                width: CGFloat = 0.0,
                height: CGFloat = 0.0) {
        translatesAutoresizingMaskIntoConstraints = false

        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        if let centerX = centerX {
            centerXAnchor.constraint(equalTo: centerX).isActive = true
        }
        if let centerY = centerY {
            centerYAnchor.constraint(equalTo: centerY).isActive = true
        }
        if width != 0.0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if height != 0.0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }

}
