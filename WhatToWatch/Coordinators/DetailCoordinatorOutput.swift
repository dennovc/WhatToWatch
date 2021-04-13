//
//  DetailCoordinatorOutput.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 12.04.2021.
//

protocol DetailCoordinatorOutput: class {

    var finishFlow: (() -> Void)? { get set }

}
