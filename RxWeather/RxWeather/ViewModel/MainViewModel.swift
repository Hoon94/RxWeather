//
//  MainViewModel.swift
//  RxWeather
//
//  Created by Daehoon Lee on 12/10/24.
//

import Foundation

class MainViewModel {
    
    // MARK: - Static
    
    static let tempFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 1
        
        return formatter
    }()
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_kr")
        
        return formatter
    }()
}
