//
//  DetailInput.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 07.04.2021.
//

import Foundation

enum DetailSection: String {

    case main
    case cast = "Cast"

}

protocol DetailInput {

    func viewDidLoad()
    func didDismiss()
    func didSelectItem(at index: Int, in section: DetailSection)

}
