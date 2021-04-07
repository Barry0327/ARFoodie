//
//  ErrorMessage.swift
//  ARFoodie
//
//  Created by Barry Chen on 2021/2/23.
//  Copyright © 2021 Chen Yi-Wei. All rights reserved.
//

import Foundation

public struct ErrorMessage: Error {
  // MARK: - Properties
  public let id: UUID
  public let title: String
  public let message: String

  // MARK: - Methods
  public init(title: String, message: String) {
    self.id = UUID()
    self.title = title
    self.message = message
  }
}

extension ErrorMessage: Equatable {

  public static func ==(lhs: ErrorMessage, rhs: ErrorMessage) -> Bool {
    return lhs.id == rhs.id
  }
}
