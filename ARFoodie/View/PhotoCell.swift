//
//  TableViewCell.swift
//  ARFoodie
//
//  Created by Chen Yi-Wei on 2019/4/1.
//  Copyright © 2019 Chen Yi-Wei. All rights reserved.
//

import UIKit

class PhotoCell: UITableViewCell {

    let restImageView: UIImageView = {

        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "pin")

        return imageView
    }()

    let labelBackground: UIView = {

        let view = UIView()
        view.backgroundColor = UIColor(r: 45, g: 52, b: 54, a: 0.5)
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    let nameLabel: UILabel = {

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "餐廳名稱"
        label.textColor = .white

        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(restImageView)
        restImageView.addSubview(labelBackground)
        labelBackground.addSubview(nameLabel)

        setUpImageView()
        setUpLabel()
        setUpLabelBackground()
    }

    required init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)

    }

    func setUpImageView() {
        restImageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        restImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        restImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        restImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
    }

    func setUpLabel() {
        nameLabel.trailingAnchor.constraint(equalTo: labelBackground.trailingAnchor, constant: -10).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: labelBackground.leadingAnchor, constant: 10).isActive = true
        nameLabel.topAnchor.constraint(equalTo: labelBackground.topAnchor, constant: 20).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: labelBackground.bottomAnchor, constant: -20).isActive = true
    }

    func setUpLabelBackground() {
        labelBackground.heightAnchor.constraint(equalToConstant: 60).isActive = true
        labelBackground.widthAnchor.constraint(equalToConstant: 200).isActive = true
        labelBackground.leadingAnchor.constraint(equalTo: restImageView.leadingAnchor).isActive = true
        labelBackground.bottomAnchor.constraint(equalTo: restImageView.bottomAnchor, constant: -20).isActive = true
    }
}
