//
//  ReviewTableViewCell.swift
//  ARFoodie
//
//  Created by Chen Yi-Wei on 2019/4/17.
//  Copyright © 2019 Chen Yi-Wei. All rights reserved.
//

import UIKit
import Firebase

class ReviewTableViewCell: UITableViewCell {
    private let profileImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.layer.cornerRadius = 25
        imgView.clipsToBounds = true
        return imgView
    }()

    private let containerView: UIView = {

        let view = UIView()

        return view
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = UIColor.flatWatermelonDark()
        return label
    }()

    private let commentBody: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 10
        return label
    }()

    private let relativeTimeDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textColor = .lightGray
        return label
    }()

    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.flatWatermelonDark()
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.backgroundColor = UIColor(hexString: "F2EDEC")
        constructViewHierarchy()
        setLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func config(with review: RestaurantDetail.Review) {
        nameLabel.text = review.authorName
        commentBody.text = review.text
        relativeTimeDescriptionLabel.text = review.relativeTimeDescription
    }

    private func constructViewHierarchy() {
        contentView.addSubview(profileImageView)
        contentView.addSubview(separatorView)

        containerView.addSubview(nameLabel)
        containerView.addSubview(commentBody)
        contentView.addSubview(containerView)
    }

    private func setLayout() {
        profileImageView.anchor(
            top: contentView.topAnchor,
            leading: contentView.leadingAnchor,
            bottom: nil,
            trailing: nil,
            padding: .init(top: 10, left: 10, bottom: 0, right: 0),
            size: .init(width: 50, height: 50)
        )

        containerView.anchor(
            top: contentView.topAnchor,
            leading: profileImageView.trailingAnchor,
            bottom: contentView.bottomAnchor,
            trailing: contentView.trailingAnchor,
            padding: .init(top: 10, left: 10, bottom: 10, right: 10)
        )

        nameLabel.anchor(
            top: contentView.topAnchor,
            leading: profileImageView.trailingAnchor,
            bottom: nil,
            trailing: nil,
            padding: .init(top: 10, left: 10, bottom: 0, right: 0),
            size: .init(width: 100, height: 20)
        )

        commentBody.anchor(
            top: nameLabel.bottomAnchor,
            leading: nameLabel.leadingAnchor,
            bottom: nil,
            trailing: contentView.trailingAnchor,
            padding: .init(top: 10, left: 10, bottom: 0, right: -10)
        )

        relativeTimeDescriptionLabel.anchor(
            top: commentBody.bottomAnchor,
            leading: nil,
            bottom: separatorView.topAnchor,
            trailing: contentView.trailingAnchor,
            padding: .init(top: 10, left: 0, bottom: 10, right: -10)
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
}
