//
//  ViewController.swift
//  ARFoodie
//
//  Created by Chen Yi-Wei on 2019/3/27.
//  Copyright © 2019 Chen Yi-Wei. All rights reserved.
//
import ARCL
import CoreLocation
import UIKit
import MapKit

class MainARViewController: UIViewController {

    var sceneLocationView = SceneLocationView()

    override func viewDidLoad() {
        super.viewDidLoad()

        let myImage = UIImage(named: "pin")!
        var restaurants: [Restaurant] = []
        let rest1 = Restaurant.init(name: "大橋頭米糕", photo: myImage, lat: 25.063294, lng: 121.518642)
        let rest2 = Restaurant.init(name: "大橋頭麻薯冰", photo: myImage, lat: 25.063804, lng: 121.518810)
        restaurants = [rest1, rest2]


        for rest in restaurants {

            let coordinate = CLLocationCoordinate2D(latitude: rest.lat, longitude: rest.lng)
            let location = CLLocation(coordinate: coordinate, altitude: 0)


            let nameLabel = UILabel(frame: CGRect(x: 130, y: 10, width: 100, height: 50))
            nameLabel.text = rest.name

            let imgView = UIImageView(frame: CGRect(x: 10, y: 10, width: 100, height: 100))
            let myImage = UIImage(named: "pin")!

            imgView.image = myImage

            let view = UIView()
            view.frame = CGRect.init(x: 0, y: 0, width: 250, height: 150)
            view.layer.cornerRadius = 0.5
            view.clipsToBounds = true
            view.addSubview(imgView)
            view.addSubview(nameLabel)
            view.backgroundColor = UIColor.clear



            let annotaionNode = LocationAnnotationNode(location: location, view: view)

            self.sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotaionNode)
        }






//        self.sceneLocationView.run()

        view.addSubview(self.sceneLocationView)

    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.sceneLocationView.frame = view.bounds
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.sceneLocationView.run()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.sceneLocationView.pause()
    }
}

extension UIColor {

    // swiftlint:disable all
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: a)

    }
}
