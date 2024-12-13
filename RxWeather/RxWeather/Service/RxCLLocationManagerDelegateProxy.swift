//
//  RxCLLocationManagerDelegateProxy.swift
//  RxWeather
//
//  Created by Daehoon Lee on 12/13/24.
//

import CoreLocation
import Foundation
import RxCocoa
import RxSwift

extension CLLocationManager: HasDelegate {
    public typealias Delegate = CLLocationManagerDelegate
}

public class RxCLLocationManagerDelegateProxy: DelegateProxy<CLLocationManager, CLLocationManagerDelegate>, DelegateProxyType, CLLocationManagerDelegate {
    
    // MARK: - Static
    
    public static func registerKnownImplementations() {
        self.register { RxCLLocationManagerDelegateProxy(locationManager: $0) }
    }
    
    // MARK: - Lifecycle
    
    public init(locationManager: CLLocationManager) {
        super.init(parentObject: locationManager, delegateProxy: RxCLLocationManagerDelegateProxy.self)
    }
}

extension Reactive where Base: CLLocationManager {
    var delegate: DelegateProxy<CLLocationManager, CLLocationManagerDelegate> {
        return RxCLLocationManagerDelegateProxy.proxy(for: base)
    }
    
    public var didUpdateLocation: Observable<[CLLocation]> {
        let selector = #selector(CLLocationManagerDelegate.locationManager(_:didUpdateLocations:))
        
        return delegate.methodInvoked(selector)
            .map { parameters in
                return parameters[1] as? [CLLocation] ?? []
            }
    }
    
    public var didChangeAuthorizationStatus: Observable<CLAuthorizationStatus> {
        let selector = #selector(CLLocationManagerDelegate.locationManagerDidChangeAuthorization(_:))
        
        return delegate.methodInvoked(selector)
            .map { parameters in
                return (parameters[0] as? CLLocationManager ?? CLLocationManager()).authorizationStatus
            }
    }
}
