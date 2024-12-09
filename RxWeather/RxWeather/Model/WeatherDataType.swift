//
//  WeatherDataType.swift
//  RxWeather
//
//  Created by Daehoon Lee on 12/9/24.
//

import Foundation

protocol WeatherDataType {
    var date: Date? { get }
    var icon: String { get }
    var description: String { get }
    var temperature: Double { get }
    var maxTemperature: Double? { get }
    var minTemperature: Double? { get }
}
