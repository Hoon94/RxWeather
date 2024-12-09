//
//  SampleData.swift
//  RxWeather
//
//  Created by Daehoon Lee on 12/10/24.
//

import Foundation

struct SampleData: WeatherDataType {
    var date: Date? { Date() }
    var icon: String { "01" }
    var description: String { "날씨 설명" }
    var temperature: Double { 19 }
    var maxTemperature: Double? { 25 }
    var minTemperature: Double? { 16 }
}
