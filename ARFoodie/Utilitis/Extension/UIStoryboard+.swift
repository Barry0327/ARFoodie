//
//  UIStoryboardExtension.swift
//  ARFoodie
//
//  Created by Barry Chen on 2021/3/30.
//  Copyright © 2021 Chen Yi-Wei. All rights reserved.
//

import UIKit

extension UIStoryboard {
    func instantiateViewController<T: UIViewController>(ofType type: T.Type) -> T? {
        return instantiateViewController(withIdentifier: String(describing: type)) as? T
    }
}
