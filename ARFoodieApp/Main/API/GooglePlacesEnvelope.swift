//
//  GooglePlacesEnvelope.swift
//  ARFoodie
//
//  Created by Barry Chen on 2021/4/1.
//  Copyright © 2021 Chen Yi-Wei. All rights reserved.
//

import Foundation

extension CodingUserInfoKey {
    static let contentIdentifier = CodingUserInfoKey(rawValue: "contentIdentifier")!
}

struct GooglePlacesEnvelope<Content: Decodable>: Decodable {
    let content: Content

    private struct CodingKeys: CodingKey {
        var stringValue: String

        init?(stringValue: String) {
            self.stringValue = stringValue
        }

        var intValue: Int?

        init?(intValue: Int) {
            return nil
        }
    }

    init(from decoder: Decoder) throws {
        guard let contentID = decoder.userInfo[.contentIdentifier],
              let contentIdentifier = contentID as? String,
              let key = CodingKeys(stringValue: contentIdentifier)
        else {
            throw GooglePlacesServiceError.invalidDecoderConfiguration
        }
        let container = try decoder.container(keyedBy: CodingKeys.self)
        content = try container.decode(Content.self, forKey: key)
    }
}
