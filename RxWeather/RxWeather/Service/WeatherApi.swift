//
//  WeatherApi.swift
//  RxWeather
//
//  Created by Daehoon Lee on 12/11/24.
//

import CoreLocation
import Foundation
import NSObject_Rx
import RxRelay
import RxSwift

class OpenWeatherMapApi: NSObject, WeatherApiType {
    
    // MARK: - Properties
    
    private let summaryRelay = BehaviorRelay<WeatherDataType?>(value: nil)
    private let forecastRelay = BehaviorRelay<[WeatherDataType]>(value: [])
    private let urlSession = URLSession.shared
    
    // MARK: - Helpers
    
    @discardableResult
    func fetch(location: CLLocation) -> RxSwift.Observable<((any WeatherDataType)?, [any WeatherDataType])> {
        let summary = fetchSummary(location: location)
        let forecast = fetchForecast(location: location)
        
        Observable.zip(summary, forecast)
            .subscribe(onNext: { [weak self] result in
                self?.summaryRelay.accept(result.0)
                self?.forecastRelay.accept(result.1)
            })
            .disposed(by: rx.disposeBag)
        
        return Observable.combineLatest(summaryRelay.asObservable(), forecastRelay.asObservable())
    }
    
    private func fetchSummary(location: CLLocation) -> Observable<WeatherDataType?> {
        let request = composeUrlRequest(endpoint: summaryEndpoint, from: location)
        
        return request
            .flatMap { [unowned self] request in
                self.urlSession.rx.data(request: request)
            }
            .map { data -> WeatherSummary in
                let decoder = JSONDecoder()
                
                return try decoder.decode(WeatherSummary.self, from: data)
            }
            .map { WeatherData(summary: $0) }
            .catchAndReturn(nil)
    }
    
    private func fetchForecast(location: CLLocation) -> Observable<[WeatherDataType]> {
        let request = composeUrlRequest(endpoint: forecastEndpoint, from: location)
        
        return request
            .flatMap { [unowned self] request in
                self.urlSession.rx.data(request: request)
            }
            .map { data -> [WeatherData] in
                let decoder = JSONDecoder()
                let forecast = try decoder.decode(Forecast.self, from: data)
                
                return forecast.list.map(WeatherData.init)
            }
            .catchAndReturn([])
    }
}
