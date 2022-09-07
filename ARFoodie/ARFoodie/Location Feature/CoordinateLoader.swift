//
//  CoordinateLoader.swift
//  ARFoodie
//
//  Created by Chen Yi-Wei on 2022/9/7.
//

import Foundation

protocol CoordinateLoader {
    typealias Completion = (Result<Coordinate, Error>) -> Void

    func loadCoordinate(completion: @escaping Completion)
}
