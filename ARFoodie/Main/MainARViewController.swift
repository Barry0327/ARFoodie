//
//  ViewController.swift
//  ARFoodie
//
//  Created by Chen Yi-Wei on 2019/3/27.
//  Copyright © 2019 Chen Yi-Wei. All rights reserved.
//
import ARCL
import UIKit
import ARKit
import TransitionButton
import RxSwift
import RxCocoa

final class MainARViewController: NiblessViewController, CLLocationManagerDelegate {
    // MARK: Properties
    private let viewModel: MainViewModel
    private let bag: DisposeBag = DisposeBag()
    private var adjustedHeight: Double = 0

    private let sceneLocationView: SceneLocationView = SceneLocationView()

    private lazy var searchButton: TransitionButton = {
        let button = TransitionButton()
        button.backgroundColor = UIColor.flatWatermelonDark()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.cornerRadius = 25
        button.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        let textAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: UIColor(hexString: "E4DAD8")!,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 25, weight: .bold)
        ]
        let attributeString = NSAttributedString(string: "找美食", attributes: textAttributes)
        button.setAttributedTitle(attributeString, for: .normal)
        button.spinnerColor = UIColor(hexString: "feffdf")!
        return button
    }()

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        constructViewHierarchy()
        activateConstraintsSearchButton()
        addTapGestureRecognizerToSceneLocationView()
        observerViewModel()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.sceneLocationView.frame = view.bounds
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.sceneLocationView.run()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.sceneLocationView.pause()
    }
    // MARK: - Methods
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init()
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

    private func observerViewModel() {
        viewModel.searchButtonAnimating.asDriver()
            .drive(onNext: { [unowned self] in
                switch $0 {
                case true: self.searchButton.startAnimation()
                case false: self.searchButton.stopAnimation()
                }
            })
            .disposed(by: bag)

        viewModel.restaurants.asDriver()
            .drive(onNext: { [unowned self] in
                self.configSceneLocationView(with: $0)
            })
            .disposed(by: bag)

        viewModel.errorMessage
            .subscribe(on: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] in
                self.present(errorMessage: $0)
            })
            .disposed(by: bag)

        viewModel.selectedPlaceID
            .subscribe(on: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] in
                self.presentDetailViewController(with: $0)
            })
            .disposed(by: bag)
    }

    private func addTapGestureRecognizerToSceneLocationView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(locationTapped(_:)))
        sceneLocationView.addGestureRecognizer(tapGesture)
        sceneLocationView.isUserInteractionEnabled = true
    }

    @objc
    private func searchButtonTapped() {
        sceneLocationView.removeAllNodes()
        adjustedHeight = 0
        viewModel.searchRestaurants()
    }

    @objc
    private func locationTapped(_ tapGestureRecognizer: UITapGestureRecognizer) {
        guard tapGestureRecognizer.state == .ended else {
            return
        }

        let location: CGPoint = tapGestureRecognizer.location(in: self.sceneLocationView)
        let hits = self.sceneLocationView.hitTest(location, options: nil)
        guard let node = hits.first?.node as? AnnotationNode else {
            print("Faield to get node")
            return
        }
        locationNodeTouched(node: node)
    }

    private func locationNodeTouched(node: AnnotationNode) {
        guard let image = node.image else { return }
        if let placeID = image.accessibilityIdentifier {
            viewModel.selectedPlaceID.accept(placeID)
        }
    }

    private func presentDetailViewController(with placeID: String) {
        let viewModel = DetailViewModel(placeID: placeID, placesService: GooglePlacesService())
        let detailViewController = DetailViewController(viewModel: viewModel)

        let navigationController = UINavigationController(rootViewController: detailViewController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }

    private func configSceneLocationView(with restaurants: [Restaurant]) {
        for restaurant in restaurants {
            let view: RestaurantPinView = RestaurantPinView(restaurant: restaurant, currentLocation: viewModel.currentLocation)
            // Convert to image to prevent flashing issue when showed in scene view
            let image = view.asImage()
            image.accessibilityIdentifier = restaurant.placeID

            let coordinate = CLLocationCoordinate2D(latitude: restaurant.lat, longitude: restaurant.lng)
            let location = CLLocation(coordinate: coordinate, altitude: 0)
            // To prevent view stack too close
            self.adjustedHeight += 5
            print(adjustedHeight)

            let annotaionNode = LocationAnnotationNode(location: location, image: image)
            annotaionNode.continuallyAdjustNodePositionWhenWithinRange = false
            annotaionNode.continuallyUpdatePositionAndScale = false
            annotaionNode.renderOnTop()

            self.sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotaionNode)
        }
    }
}
