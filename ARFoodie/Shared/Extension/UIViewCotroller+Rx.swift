//
//  UIViewCotroller+Rx.swift
//  ARFoodie
//
//  Created by Barry Chen on 2021/3/30.
//  Copyright © 2021 Chen Yi-Wei. All rights reserved.
//

import Foundation
import RxSwift
import IHProgressHUD

extension Reactive where Base: UIViewController {
    public var isActivityIndicatorAnimating: Binder<Bool> {
        return Binder.init(self.base, scheduler: MainScheduler.instance) { (_, isAnimating) in
            switch isAnimating {
            case true: IHProgressHUD.show()
            case false: IHProgressHUD.dismiss()
            }
        }
    }
}
