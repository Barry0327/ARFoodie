//
//  GooglePlaceService.swift
//  ARFoodie
//
//  Created by Barry Chen on 2021/4/1.
//  Copyright © 2021 Chen Yi-Wei. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

typealias Coordinate = (lat: String, lng: String)

enum GooglePlacesServiceError: Error {
    case invalidDecoderConfiguration
}

final class GooglePlacesService: PlacesService {
    private struct ResturantParameters: Codable {
        let location: String
        let rankby: String
        let types: String
        let language: String
        let key: String
    }

    struct RestaurantDetailParameters: Codable {
        let placeid: String
        let key: String
        let language: String
    }

    private let apiKey: String = Secrets.apiKey

    private var urlComponents: URLComponents {
        let url = "https://maps.googleapis.com"
        let components = URLComponents(string: url)!
        return components
    }

    func nearbyRestaurants(coordinate: Coordinate) -> Single<[Restaurant]> {
        let endPointURL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json"

        let parameters = ResturantParameters(
            location: "\(coordinate.lat),\(coordinate.lng)",
            rankby: "distance",
            types: "restaurant",
            language: "zh_TW",
            key: apiKey
        )

        let decoder = JSONDecoder()
        decoder.userInfo[.contentIdentifier] = "results"

        return Single<[Restaurant]>.create { (single) -> Disposable in
            let request = AF.request(endPointURL, method: .get, parameters: parameters, encoder: URLEncodedFormParameterEncoder.default)
            request.responseDecodable(of: GooglePlacesEnvelope<[Restaurant]>.self, decoder: decoder) { (response) in
                switch response.result {
                case .success(let envelope):
                    single(.success(envelope.content))
                case .failure(let error):
                    single(.failure(error))
                }
            }
            return Disposables.create {
                request.cancel()
            }
        }
    }

    func restaurantDetail(placeID: String) -> Single<RestaurantDetail> {
        let endPointURL = "https://maps.googleapis.com/maps/api/place/details/json"

        let parameters = RestaurantDetailParameters(
            placeid: placeID,
            key: apiKey,
            language: "zh_TW"
        )

        let decoder = JSONDecoder()
        decoder.userInfo[.contentIdentifier] = "result"

        return Single<RestaurantDetail>.create { (single) -> Disposable in
            let request = AF.request(endPointURL, method: .get, parameters: parameters, encoder: URLEncodedFormParameterEncoder.default)
            request.responseDecodable(of: GooglePlacesEnvelope<RestaurantDetail>.self, decoder: decoder) { (response) in
                switch response.result {
                case .success(let envelope):
                    single(.success(envelope.content))
                case .failure(let error):
                    single(.failure(error))
                }
            }
            return Disposables.create {
                request.cancel()
            }
        }
    }
}
