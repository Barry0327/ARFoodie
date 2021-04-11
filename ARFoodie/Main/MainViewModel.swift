//
//  MainViewModel.swift
//  ARFoodie
//
//  Created by Barry Chen on 2021/3/31.
//  Copyright © 2021 Chen Yi-Wei. All rights reserved.
//

import Foundation
import CoreLocation.CLLocation
import RxRelay
import RxSwift

final class MainViewModel {
    private let placesService: PlacesService
    private let locationService: LocationService

    private let bag: DisposeBag = DisposeBag()
    var currentLocation: CLLocation? {
        locationService.currentLocation
    }
    let searchButtonAnimating: BehaviorRelay<Bool> = .init(value: false)
    let restaurants: BehaviorRelay<[Restaurant]> = .init(value: [])
    let selectedPlaceID: PublishRelay<String> = .init()
    let errorMessage: PublishRelay<ErrorMessage> = .init()

    init(placesService: PlacesService,
         locationService: LocationService) {
        self.placesService = placesService
        self.locationService = locationService
        observerLocatoinService()
    }

    func observerLocatoinService() {
        locationService.coordinate.asObservable()
            .subscribe(onNext: { [unowned self] in
                self.searchPlaces(with: $0)
            })
            .disposed(by: bag)

        locationService.locationError.asObservable()
            .subscribe(onNext: { [unowned self] in
                let message = ErrorMessage(title: "定位失敗", message: $0.localizedDescription)
                errorMessage.accept(message)
            })
            .disposed(by: bag)
    }

    func searchRestaurants() {
        searchButtonAnimating.accept(true)
        getCurrentLocation()
    }

    func getCurrentLocation() {
        locationService.getCurrentLocation()
    }

    func searchPlaces(with coordinate: Coordinate) {
        placesService.nearbyRestaurants(coordinate: coordinate)
            .subscribe(on: MainScheduler.instance)
            .subscribe { [unowned self] in
                switch $0 {
                case .success(let restaurants):
                    self.restaurants.accept(restaurants)
                case .failure(let error):
                    let message = ErrorMessage(title: "連線錯誤", message: error.localizedDescription)
                    self.errorMessage.accept(message)
                }
                self.searchButtonAnimating.accept(false)
            }
            .disposed(by: bag)
    }
}
