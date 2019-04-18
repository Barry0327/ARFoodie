//
//  CommentCell.swift
//  ARFoodie
//
//  Created by Chen Yi-Wei on 2019/4/17.
//  Copyright © 2019 Chen Yi-Wei. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {

    let profileImageView: UIImageView = {

        let imgView = UIImageView()
        imgView.layer.cornerRadius = 25
        return imgView
    }()

    let containerView: UIView = {

        let view = UIView()

        return view
    }()

    let nameLabel: UILabel = {

        let label = UILabel()

        return label
    }()

    lazy var commentBody: UILabel = {

        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 10

        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(profileImageView)
        contentView.addSubview(containerView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(commentBody)

        setLayout()

    }

    required init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)

    }

    func setLayout() {

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
            top: containerView.topAnchor,
            leading: containerView.leadingAnchor,
            bottom: nil,
            trailing: nil,
            padding: .init(top: 0, left: 10, bottom: 0, right: 0),
            size: .init(width: 100, height: 20)
        )

        commentBody.anchor(
            top: nameLabel.bottomAnchor,
            leading: containerView.leadingAnchor,
            bottom: containerView.bottomAnchor,
            trailing: containerView.trailingAnchor,
            padding: .init(top: 10, left: 10, bottom: 10, right: 10)
        )

    }
}