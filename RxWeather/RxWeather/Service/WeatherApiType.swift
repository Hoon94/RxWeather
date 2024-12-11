//
//  WeatherApiType.swift
//  RxWeather
//
//  Created by Daehoon Lee on 12/11/24.
//

import CoreLocation
import Foundation
import RxSwift

protocol WeatherApiType {
    @discardableResult
    func fetch(location: CLLocation) -> Observable<(WeatherDataType?, [WeatherDataType])>
}
