//
//  Scene.swift
//  RxWeather
//
//  Created by Daehoon Lee on 12/11/24.
//

import UIKit

enum Scene {
    case main(MainViewModel)
}

extension Scene {
    func instantiate() -> UIViewController {
        switch self {
        case .main(let viewModel):
            var viewController = ViewController()
            
            DispatchQueue.main.async {
                viewController.bind(viewModel: viewModel)
            }
            
            return viewController
        }
    }
}
