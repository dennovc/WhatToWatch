//
//  NALabel.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 11.04.2021.
//

import UIKit

final class NALabel: UILabel {

    override var text: String? {
        get { super.text }
        set { super.text = newValue ?? "N/A" }
    }

}
