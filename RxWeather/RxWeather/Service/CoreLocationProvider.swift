//
//  CoreLocationProvider.swift
//  RxWeather
//
//  Created by Daehoon Lee on 12/14/24.
//

import CoreLocation
import Foundation
import RxCocoa
import RxSwift

class CoreLocationProvider: LocationProviderType {
    
    // MARK: - Properties
    
    private let locationManager = CLLocationManager()
    
    private let location = BehaviorRelay<CLLocation>(value: .init(latitude: 37.498206, longitude: 127.02761))
    
    private let address = BehaviorRelay<String>(value: "강남역")
    
    private let authorized = BehaviorRelay<Bool>(value: false)
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    
    init() {
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        locationManager.rx.didUpdateLocation
            .throttle(.seconds(5), scheduler: MainScheduler.instance)
            .map { $0.last ?? CLLocation(latitude: 37.498206, longitude: 127.02761) }
            .bind(to: location)
            .disposed(by: disposeBag)
        
        location.flatMap { location in
            return Observable<String>.create { observer in
                let geocoder = CLGeocoder()
                
                geocoder.reverseGeocodeLocation(location) { placemarks, error in
                    if let place = placemarks?.first {
                        if let gu = place.locality, let dong = place.subLocality {
                            observer.onNext("\(gu) \(dong)")
                        } else {
                            observer.onNext(place.name ?? "알 수 없음")
                        }
                    } else {
                        observer.onNext("알 수 없음")
                    }
                    
                    observer.onCompleted()
                }
                
                return Disposables.create()
            }
        }
        .bind(to: address)
        .disposed(by: disposeBag)
        
        locationManager.rx.didChangeAuthorizationStatus
            .map { $0 == .authorizedAlways || $0 == .authorizedWhenInUse }
            .bind(to: authorized)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Helpers
    
    @discardableResult
    func currentLocation() -> RxSwift.Observable<CLLocation> {
        return location.asObservable()
    }
    
    @discardableResult
    func currentAddress() -> RxSwift.Observable<String> {
        return address.asObservable()
    }
}
