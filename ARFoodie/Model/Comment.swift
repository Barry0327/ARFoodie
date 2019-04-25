//
//  Comment.swift
//  ARFoodie
//
//  Created by Chen Yi-Wei on 2019/4/18.
//  Copyright © 2019 Chen Yi-Wei. All rights reserved.
//

import Foundation
import Firebase

struct Comment {

    let senderName: String

    let senderUid: String

    let content: String

    var commentUID: String?

    init(name: String, uid: String, content: String) {

        self.senderName = name
        self.senderUid = uid
        self.content = content
    }

    init?(snapshot: DataSnapshot) {

        guard
            let value = snapshot.value as? [String: Any],
            let senderName = value["senderName"] as? String,
            let senderUid = value["senderUid"] as? String,
            let content = value["content"] as? String
            else { return nil }

        self.senderName = senderName
        self.senderUid = senderUid
        self.content = content
        self.commentUID = snapshot.key

    }

    func toAnyObject() -> Any {
        return [
            "senderName": self.senderName,
            "senderUid": self.senderUid,
            "content": self.content
        ]
    }

}
