//
//  ARRestaurantUIComposer.swift
//  ARFoodieApp
//
//  Created by Chen Yi-Wei on 2022/9/18.
//  Copyright © 2022 Chen Yi-Wei. All rights reserved.
//

import Combine
import ARFoodie
import ARFoodieiOS

public final class ARRestaurantUIComposer {
    private init() {}

    public static func arRestaurantUIComposedWith(loader: @escaping () -> AnyPublisher<[Restaurant], Error>) -> ARRestaurantViewController {
        let viewModel = RestaurantViewModel(loader: loader)
        let viewController = ARRestaurantViewController(viewModel: viewModel)

        return viewController
    }
}


