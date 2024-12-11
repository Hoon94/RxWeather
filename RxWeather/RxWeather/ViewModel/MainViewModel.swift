//
//  MainViewModel.swift
//  RxWeather
//
//  Created by Daehoon Lee on 12/10/24.
//

import Foundation
import NSObject_Rx
import RxCocoa
import RxDataSources
import RxSwift

typealias SectionModel = AnimatableSectionModel<Int, WeatherData>

class MainViewModel: HasDisposeBag {
    
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
    
    // MARK: - Properties
    
    let title: BehaviorRelay<String>
    
    let sceneCoordinator: SceneCoordinatorType
    let weatherApi: WeatherApiType
    let locationProvider: LocationProviderType
    
    var weatherData: Driver<[SectionModel]> {
        return locationProvider.currentLocation()
            .flatMap { [unowned self] in
                self.weatherApi.fetch(location: $0)
                    .asDriver(onErrorJustReturn: (nil, [WeatherDataType]()))
            }
            .map { (summary, forecast) in
                var summaryList = [WeatherData]()
                
                if let summary = summary as? WeatherData {
                    summaryList.append(summary)
                }
                
                return [
                    SectionModel(model: 0, items: summaryList),
                    SectionModel(model: 1, items: forecast as? [WeatherData] ?? [])
                ]
            }
            .asDriver(onErrorJustReturn: [])
    }
    
    // MARK: - Lifecycle
    
    init(title: String, sceneCoordinator: SceneCoordinatorType, weatherApi: WeatherApiType, locationProvider: LocationProviderType) {
        self.title = BehaviorRelay(value: title)
        self.sceneCoordinator = sceneCoordinator
        self.weatherApi = weatherApi
        self.locationProvider = locationProvider
        
        locationProvider.currentAddress()
            .bind(to: self.title)
            .disposed(by: disposeBag)
    }
}
