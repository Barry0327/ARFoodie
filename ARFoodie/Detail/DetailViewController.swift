//
//  DetailViewController.swift
//  ARFoodie
//
//  Created by Chen Yi-Wei on 2019/4/24.
//  Copyright © 2019 Chen Yi-Wei. All rights reserved.
//

import UIKit
import GoogleMaps
import ChameleonFramework
import RxSwift
import RxCocoa
import IHProgressHUD

class DetailViewController: NiblessViewController, UINavigationControllerDelegate {
    // MARK: Properties
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    let viewModel: DetailViewModel
    let bag: DisposeBag = DisposeBag()
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor.init(hexString: "F2EDEC")
        return tableView
    }()

    lazy var dismissBTN: UIBarButtonItem = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "icon-cross"), for: .normal)
        button.frame = CGRect(x: 11, y: 20, width: 19, height: 19)
        button.tintColor = UIColor.init(hexString: "F2EDEC")
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        let leftBarButton = UIBarButtonItem(customView: button)
        return leftBarButton
    }()

    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
        configNavigationBar()

        view.addSubview(tableView)
        setLayout()
        observerViewModel()
        viewModel.fetchRestaurtantDetail()
    }
    // MARK: - Methods
    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    deinit {
        print("DetailView deinit")
    }

    private func setLayout() {
        tableView.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            leading: view.leadingAnchor,
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            trailing: view.trailingAnchor
        )
    }

    private func configTableView() {
        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(InformationCell.self, forCellReuseIdentifier: "InformationCell")
        tableView.register(MapCell.self, forCellReuseIdentifier: "MapCell")
        tableView.register(ReviewTableViewCell.self, forCellReuseIdentifier: "CommentCell")

        tableView.separatorStyle = .none
    }

    private func configNavigationBar() {
        navigationController?.navigationBar.barTintColor = UIColor.flatWatermelonDark()
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor(hexString: "F2EDEC")!,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 21, weight: .bold)
        ]
        navigationItem.setLeftBarButton(dismissBTN, animated: true)
    }

    func observerViewModel() {
        viewModel.restaurantDetail.asDriver()
            .drive(onNext: { [unowned self] _ in
                self.tableView.reloadData()
            })
            .disposed(by: bag)

        viewModel.navigationTitle.asDriver()
            .drive(onNext: { [unowned self] in
                self.navigationItem.title = $0
            })
            .disposed(by: bag)

        viewModel.activityIndicatorAnimating.asDriver()
            .drive(onNext: {
                switch $0 {
                case true: IHProgressHUD.show()
                case false: IHProgressHUD.dismiss()
                }
            })
            .disposed(by: bag)

        viewModel.selectedPhoneNumberURL.asObservable()
            .subscribe(onNext: { url in
                UIApplication.shared.open(url)
            })
            .disposed(by: bag)

        viewModel.errorMessage.asObservable()
            .subscribe(on: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] in
                self.present(errorMessage: $0)
            })
            .disposed(by: bag)
    }

    @objc func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}
// MARK: - Table view data source
extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.detailSections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = viewModel.detailSections[section]
        switch section {
        case .review:
            let reviews = viewModel.restaurantDetail.value.reviews
            return reviews.count
        default: return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = viewModel.detailSections[indexPath.section]
        switch section {
        case .map:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MapCell", for: indexPath) as? MapCell else { fatalError() }
            let detail = viewModel.restaurantDetail.value
            cell.config(with: detail)
            cell.mapView.delegate = self
            return cell
        case .information:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "InformationCell", for: indexPath) as? InformationCell else { fatalError() }
            let detail = viewModel.restaurantDetail.value
            cell.config(with: detail)
            cell.phoneButton.addTarget(viewModel, action: #selector(DetailViewModel.selectPhoneNumber), for: .touchUpInside)
            return cell
        case .review:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as? ReviewTableViewCell else { fatalError() }
            let review = viewModel.restaurantDetail.value.reviews[indexPath.row]
            cell.config(with: review)
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = viewModel.detailSections[indexPath.section]
        switch section {
        case .information:
            return 120
        case .map:
            return 200
        case .review:
            return UITableView.automaticDimension
        }
    }
}
extension DetailViewController: GMSMapViewDelegate {
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        guard let url = URL(string: "https://www.google.com/maps/search/?api=1&query=restaurant&query_place_id=\(viewModel.placeID)")
            else {
                return false
        }
        UIApplication.shared.open(
            url,
            options: [UIApplication.OpenExternalURLOptionsKey.universalLinksOnly: true]
        )
        return true
    }
}
