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
    @Published private(set) var isLoading: Bool = false
    private var cancellable: AnyCancellable?

    public init(loader: @escaping () -> AnyPublisher<[Restaurant], Error>) {
        self.loader = loader
    }

    public func load() {
        guard isLoading == false else { return }
        isLoading = true

        cancellable = loader()
            .sink { [weak self] completion in
                self?.isLoading = false
            } receiveValue: { restaurants in

            }
    }
}
