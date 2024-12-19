//
//  StaticLocationProvider.swift
//  RxWeather
//
//  Created by Daehoon Lee on 12/11/24.
//

import CoreLocation
import Foundation
import RxSwift

struct StaticLocationProvider: LocationProviderType {
    
    // MARK: - Helpers
    
    @discardableResult
    func currentLocation() -> RxSwift.Observable<CLLocation> {
        return Observable.just(CLLocation.gangnamStation)
    }
    
    @discardableResult
    func currentAddress() -> RxSwift.Observable<String> {
        return Observable.just("강남역")
    }
}
