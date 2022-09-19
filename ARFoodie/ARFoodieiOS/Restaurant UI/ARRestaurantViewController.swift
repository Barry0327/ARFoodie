//
//  ARRestaurantViewController.swift
//  ARFoodieiOS
//
//  Created by Chen Yi-Wei on 2022/8/22.
//

import UIKit
import ARCL
import TransitionButton
import ChameleonFramework
import ARFoodie

public final class ARRestaurantViewController: UIViewController {
    private let sceneLocationView: SceneLocationView = SceneLocationView()

    public private(set) lazy var searchButton: TransitionButton = {
        let button = TransitionButton()
        button.backgroundColor = UIColor.flatWatermelonDark()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.cornerRadius = 25
//        button.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        let textAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: UIColor(hexString: "E4DAD8")!,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 25, weight: .bold)
        ]
        let attributeString = NSAttributedString(string: "找美食", attributes: textAttributes)
        button.setAttributedTitle(attributeString, for: .normal)
        button.spinnerColor = UIColor(hexString: "feffdf")!
        button.addTarget(self, action: #selector(searchButtonDidTap), for: .touchUpInside)
        return button
    }()

    let viewModel: RestaurantViewModel

    public init(viewModel: RestaurantViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        constructViewHierarchy()
        activateConstraintsSearchButton()
    }

    public override func viewDidLayoutSubviews() {
        sceneLocationView.frame = view.bounds
    }

    private func constructViewHierarchy() {
        view.addSubview(sceneLocationView)
        view.addSubview(searchButton)
    }

    private func activateConstraintsSearchButton() {
        let width = searchButton.widthAnchor
            .constraint(equalToConstant: 180)
        let height = searchButton.heightAnchor
            .constraint(equalToConstant: 50)
        let bottom = searchButton.bottomAnchor
            .constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        let centerX = searchButton.centerXAnchor
            .constraint(equalTo: view.centerXAnchor)

        NSLayoutConstraint.activate([
            width, height, bottom, centerX
        ])
    }

    @objc
    private func searchButtonDidTap() {
        searchButton.startAnimation()
        viewModel.load()
    }
}
