//
//  InformationCell.swift
//  ARFoodie
//
//  Created by Chen Yi-Wei on 2019/4/24.
//  Copyright © 2019 Chen Yi-Wei. All rights reserved.
//

import UIKit
import Cosmos
import ChameleonFramework
import Kingfisher

class InformationCell: UITableViewCell {
    // MARK: - Properties
    private let placeImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.layer.cornerRadius = 5
        imgView.clipsToBounds = true
        imgView.tintColor = .gray
        imgView.image = UIImage(named: "icon-placeholder")
        imgView.contentMode = .center
        return imgView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = UIColor.flatWatermelonDark()
        return label
    }()

    private let ratingView: CosmosView = {
        let ratingView = CosmosView()
        ratingView.settings.updateOnTouch = false
        ratingView.settings.starSize = 16
        ratingView.settings.starMargin = 1
        ratingView.settings.fillMode = .half
        ratingView.settings.filledColor = UIColor.flatWatermelonDark()
        ratingView.settings.filledBorderColor = UIColor.flatWatermelonDark()
        ratingView.settings.emptyBorderColor = UIColor.flatWatermelonDark()
        return ratingView
    }()

    let phoneButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.flatSkyBlue(), for: .normal)
        return button
    }()

    private let addressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 2
        label.textColor = .black
        return label
    }()

    private let isOpeningIconImageView: UIImageView = UIImageView()

    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.flatWatermelonDark()
        return view
    }()
    // MARK: - Methods
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor(hexString: "F2EDEC")
        constructViewHierarchy()
        setLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func constructViewHierarchy() {
        contentView.addSubview(placeImageView)
        contentView.addSubview(isOpeningIconImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(ratingView)
        contentView.addSubview(phoneButton)
        contentView.addSubview(addressLabel)
        contentView.addSubview(separatorView)
    }

    private func setLayout() {
        placeImageView.anchor(
            top: nil,
            leading: contentView.leadingAnchor,
            bottom: nil,
            trailing: nil,
            padding: .init(top: 0, left: 10, bottom: 0, right: 0),
            size: .init(width: 80, height: 100)
        )

        placeImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true

        isOpeningIconImageView.anchor(
            top: contentView.topAnchor,
            leading: nil,
            bottom: nil,
            trailing: contentView.trailingAnchor,
            padding: .init(top: 10, left: 0, bottom: 0, right: 10),
            size: .init(width: 30, height: 30)
        )

        nameLabel.anchor(
            top: contentView.topAnchor,
            leading: placeImageView.trailingAnchor,
            bottom: nil,
            trailing: isOpeningIconImageView.leadingAnchor,
            padding: .init(top: 10, left: 10, bottom: 0, right: 10),
            size: .init(width: 0, height: 20)
        )

        ratingView.anchor(
            top: nameLabel.bottomAnchor,
            leading: nameLabel.leadingAnchor,
            bottom: nil,
            trailing: nil,
            padding: .init(top: 5, left: 0, bottom: 0, right: 0),
            size: .init(width: 150, height: 15)
        )

        phoneButton.anchor(
            top: ratingView.bottomAnchor,
            leading: nameLabel.leadingAnchor,
            bottom: nil,
            trailing: nil,
            padding: .init(top: 5, left: 0, bottom: 0, right: 0),
            size: .init(width: 150, height: 15)
        )

        addressLabel.anchor(
            top: phoneButton.bottomAnchor,
            leading: nameLabel.leadingAnchor,
            bottom: nil,
            trailing: contentView.trailingAnchor,
            padding: .init(top: 5, left: 0, bottom: 0, right: 10),
            size: .init(width: 0, height: 45)
        )

        separatorView.anchor(
            top: nil,
            leading: contentView.leadingAnchor,
            bottom: contentView.bottomAnchor,
            trailing: contentView.trailingAnchor,
            padding: .init(top: 0, left: 10, bottom: 1, right: 10),
            size: .init(width: 0, height: 1)
        )
    }

    func config(with detail: RestaurantDetail) {
        addressLabel.text = detail.address
        nameLabel.text = detail.name
        phoneButton.setTitle(detail.phoneNumber, for: .normal)
        ratingView.rating = detail.rating ?? 0
        ratingView.text = String(detail.userRatingsTotal ?? 0)

        if let imageURL = detail.photo?.url {
            placeImageView.kf.setImage(with: imageURL)
        }

        if let isOpening = detail.isOpening {
            switch isOpening {
            case true:
                isOpeningIconImageView.image = UIImage(named: "icons8-open-sign-100")
                isOpeningIconImageView.tintColor = UIColor.flatGreenDark()
            case false:
                isOpeningIconImageView.image = UIImage(named: "icons8-closed-sign-100")
                isOpeningIconImageView.tintColor = UIColor.flatGreenDark()
            }
        }
    }
}
