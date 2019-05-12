//
//  CommentCell.swift
//  ARFoodie
//
//  Created by Chen Yi-Wei on 2019/4/17.
//  Copyright © 2019 Chen Yi-Wei. All rights reserved.
//

import UIKit
import Firebase

class CommentCell: UITableViewCell {

    var comment: Comment? {

        didSet {

            guard comment != nil else {

                self.commentBody.text = "尚無評論"
                self.commentBody.textColor = .gray
                return

            }

            self.nameLabel.text = comment!.senderName
            self.commentBody.text = comment!.content
            self.commentBody.textColor = .black
            FirebaseManager.shared.fetchProfileImage(
                userUid: comment!.senderUid,
                imgView: self.profileImageView)
        }
    }

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
        label.textColor = UIColor.flatWatermelonDark

        return label
    }()

    private let commentBody: UILabel = {

        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 10

        return label
    }()

    private let separatorView: UIView = {

        let view = UIView()
        view.backgroundColor = UIColor.flatWatermelonDark

        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.backgroundColor = UIColor(hexString: "F2EDEC")

        contentView.addSubview(profileImageView)
        contentView.addSubview(containerView)
        contentView.addSubview(separatorView)

        containerView.addSubview(nameLabel)
        containerView.addSubview(commentBody)

        selectionStyle = .none

        setLayout()

    }

    required init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)

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
