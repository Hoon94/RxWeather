//
//  TransitionModel.swift
//  RxWeather
//
//  Created by Daehoon Lee on 12/11/24.
//

import Foundation

// MARK: - TransitionStyle

enum TransitionStyle {
    case root
    case push
    case modal
}

// MARK: - TransitionError

enum TransitionError: Error {
    case navigationControllerMissing
    case cannotPop
    case unknown
}
