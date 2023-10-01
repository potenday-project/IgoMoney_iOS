//
//  AuthToken.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

struct AuthToken: Codable, Equatable {
  let userID: Int
  let accessToken: String
  let expiresAt: String
  let idToken: String
  let refreshToken: String
  let tokenType: String
  let createdAt: Date = Date()
  
  var isExpired: Bool {
    return createdAt.addingTimeInterval(TimeInterval(expiresAt) ?? 0) < Date().addingTimeInterval(86400)
  }
  
  enum CodingKeys: String, CodingKey {
    case userID = "userId"
    case accessToken = "access_token"
    case expiresAt = "expires_in"
    case idToken = "id_token"
    case refreshToken = "refresh_token"
    case tokenType = "token_type"
  }
}
