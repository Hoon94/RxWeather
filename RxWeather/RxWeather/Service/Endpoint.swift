//
//  Endpoint.swift
//  RxWeather
//
//  Created by Daehoon Lee on 12/11/24.
//

import CoreLocation
import Foundation

let summaryEndpoint = "https://api.openweathermap.org/data/2.5/weather"
let forecastEndpoint = "https://api.openweathermap.org/data/2.5/forecast"

func composeUrlRequest(endpoint: String, from location: CLLocation) -> URLRequest {
    let urlStr = "\(endpoint)?lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&appid=\(apiKey)&lang=kr&units=metric"
    
    guard let url = URL(string: urlStr) else { fatalError() }
    
    return URLRequest(url: url)
}
