//
//  DetailViewModel.swift
//  ARFoodie
//
//  Created by Barry Chen on 2021/4/6.
//  Copyright © 2021 Chen Yi-Wei. All rights reserved.
//

import Foundation
import RxRelay
import RxSwift

class DetailViewModel {
    enum DetailSection {
        case information, map, review
    }
    // MARK: Properties
    let placeID: String
    let placesService: PlacesService

    let detailSections: [DetailSection] = [
        .map,
        .information,
        .review
    ]
    let bag: DisposeBag = DisposeBag()
    let restaurantDetail: BehaviorRelay<RestaurantDetail> = .init(value: .empty())
    let navigationTitle: BehaviorRelay<String> = .init(value: "")
    let activityIndicatorAnimating: BehaviorRelay<Bool> = .init(value: true)
    let selectedPhoneNumberURL: PublishRelay<URL> = .init()
    let errorMessage: PublishRelay<ErrorMessage> = .init()
    // MARK: Methods
    init(placeID: String, placesService: PlacesService) {
        self.placeID = placeID
        self.placesService = placesService
    }

    func fetchRestaurtantDetail() {
        placesService.restaurantDetail(placeID: placeID)
            .subscribe { [unowned self] (result) in
                defer { self.activityIndicatorAnimating.accept(false) }
                switch result {
                case .success(let restaurantDetail):
                    self.restaurantDetail.accept(restaurantDetail)
                    self.navigationTitle.accept(restaurantDetail.name)
                case .failure(let error):
                    let message = ErrorMessage(title: "連線失敗", message: error.localizedDescription)
                    self.errorMessage.accept(message)
                }
            }
            .disposed(by: bag)
    }

    @objc
    func selectPhoneNumber() {
        guard
            let phoneNumber = restaurantDetail.value.phoneNumber?.digits,
            let phoneNumberURL = URL(string: "tel://\(phoneNumber)")
        else {
            let message = ErrorMessage(title: "格式錯誤", message: "電話號碼格式不正確")
            errorMessage.accept(message)
            return
        }
        selectedPhoneNumberURL.accept(phoneNumberURL)
    }
}
