//
//  CrashlyticsTest.swift
//  ARFoodie
//
//  Created by Chen Yi-Wei on 2019/4/18.
//  Copyright © 2019 Chen Yi-Wei. All rights reserved.
//

import UIKit
import Crashlytics

class CrashlyticsTestViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.

        let button = UIButton(type: .roundedRect)
        button.frame = CGRect(x: 20, y: 50, width: 100, height: 30)
        button.setTitle("Crash", for: [])
        button.addTarget(self, action: #selector(self.crashButtonTapped(_:)), for: .touchUpInside)
        view.addSubview(button)
    }

    @objc func crashButtonTapped(_ sender: AnyObject) {
        print("Run")
        Crashlytics.sharedInstance().crash()
    }
}
