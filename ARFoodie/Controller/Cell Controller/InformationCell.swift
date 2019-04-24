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

class InformationCell: UITableViewCell {

    let imgView: UIImageView = {

        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.layer.cornerRadius = 20
        imgView.clipsToBounds = true

        return imgView

    }()

    let nameLabel: UILabel = {

        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = UIColor.flatWatermelonDark

        return label
    }()

    let ratingView: CosmosView = {

        let ratingView = CosmosView()
        ratingView.settings.updateOnTouch = false
        ratingView.settings.starSize = 16
        ratingView.settings.starMargin = 1
        ratingView.settings.fillMode = .half
        ratingView.settings.filledColor = UIColor.flatWatermelonDark
        ratingView.settings.filledBorderColor = UIColor.flatWatermelonDark
        ratingView.settings.emptyBorderColor = UIColor.flatWatermelonDark

        return ratingView

    }()

    let phoneLabel: UILabel = {

        let label = UILabel()
        label.textColor = UIColor.flatSkyBlue
        label.isUserInteractionEnabled = true

        return label
    }()

    let addressLabel: UILabel = {

        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 2

        return label
    }()

    let isOpeningIcon: UIImageView = {

        let imgView = UIImageView()

        return imgView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(imgView)
        contentView.addSubview(isOpeningIcon)
        contentView.addSubview(nameLabel)
        contentView.addSubview(ratingView)
        contentView.addSubview(phoneLabel)
        contentView.addSubview(addressLabel)

        setLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setLayout() {

        imgView.anchor(
            top: nil,
            leading: contentView.leadingAnchor,
            bottom: nil,
            trailing: nil,
            padding: .init(top: 0, left: 10, bottom: 0, right: 0),
            size: .init(width: 80, height: 100)
        )

        imgView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true

        isOpeningIcon.anchor(
            top: contentView.topAnchor,
            leading: nil,
            bottom: nil,
            trailing: contentView.trailingAnchor,
            padding: .init(top: 10, left: 0, bottom: 0, right: 10),
            size: .init(width: 30, height: 30)
        )

        nameLabel.anchor(
            top: contentView.topAnchor,
            leading: imgView.trailingAnchor,
            bottom: nil,
            trailing: isOpeningIcon.leadingAnchor,
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

        phoneLabel.anchor(
            top: ratingView.bottomAnchor,
            leading: nameLabel.leadingAnchor,
            bottom: nil,
            trailing: nil,
            padding: .init(top: 5, left: 0, bottom: 0, right: 0),
            size: .init(width: 150, height: 15)
        )

        addressLabel.anchor(
            top: phoneLabel.bottomAnchor,
            leading: nameLabel.leadingAnchor,
            bottom: nil,
            trailing: contentView.trailingAnchor,
            padding: .init(top: 5, left: 0, bottom: 0, right: 10),
            size: .init(width: 0, height: 45)
        )
    }
}
