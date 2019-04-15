//
//  LFLiveViewController.swift
//  ARFoodie
//
//  Created by Chen Yi-Wei on 2019/4/15.
//  Copyright © 2019 Chen Yi-Wei. All rights reserved.
//

import UIKit
import LFLiveKit
import YTLiveStreaming

class LFLiveViewController: UIViewController {

    let lfView = LFLivePreview()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(lfView)
        lfView.frame = view.frame
    }

    override func viewWillAppear(_ animated: Bool) {

        DispatchQueue.main.async { [weak self] in

            guard let self = self else { return }

            self.lfView.prepareForUsing()
        }
    }
}
