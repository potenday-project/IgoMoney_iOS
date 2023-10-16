//
//  AuthToken.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

struct AuthToken: Codable, Equatable {
  let userID: Int
  let accessToken: String
  let refreshToken: String
  let providerToken: String?
  
  enum CodingKeys: String, CodingKey {
    case userID = "userId"
    case accessToken = "accessToken"
    case refreshToken = "refreshToken"
    case providerToken = "provider_accessToken"
  }
}
