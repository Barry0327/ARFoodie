//
//  RestaurantViewModel.swift
//  ARFoodie
//
//  Created by Chen Yi-Wei on 2022/8/18.
//

import Foundation
import Combine

public final class RestaurantViewModel {
    let loader: () -> AnyPublisher<[Restaurant], Error>

    public init(loader: @escaping () -> AnyPublisher<[Restaurant], Error>) {
        self.loader = loader
    }

    public func load() {
        loader()
            .sink { completion in

            } receiveValue: { restaurants in

            }
    }
}
