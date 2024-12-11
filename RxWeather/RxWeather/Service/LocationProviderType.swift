//
//  LocationProviderType.swift
//  RxWeather
//
//  Created by Daehoon Lee on 12/11/24.
//

import CoreLocation
import Foundation
import RxSwift

protocol LocationProviderType {
    @discardableResult
    func currentLocation() -> Observable<CLLocation>
    
    @discardableResult
    func currentAddress() -> Observable<String>
}
