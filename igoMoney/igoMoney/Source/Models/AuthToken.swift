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
  let expireTime: Date
  
  var isExpired: Bool {
    return expireTime < Date().addingTimeInterval(-3000)
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.userID = try container.decode(Int.self, forKey: .userID)
    self.accessToken = try container.decode(String.self, forKey: .accessToken)
    self.refreshToken = try container.decode(String.self, forKey: .refreshToken)
    self.providerToken = try container.decodeIfPresent(String.self, forKey: .providerToken)
    
    #if DEBUG
    var dateComponent = DateComponents()
    dateComponent.year = 2023
    dateComponent.month = 9
    dateComponent.day = 10
    dateComponent.hour = 23
    dateComponent.minute = 40
    dateComponent.second = .zero
    dateComponent.nanosecond = .zero
    
    expireTime = Calendar.current.date(from: dateComponent) ?? Date()
    
    print(#fileID, #function, #line, "expired Time", expireTime)
    
    #else
    expireTime = Date().addingTimeInterval(TimeInterval(3600))
    #endif
  }
  
  enum CodingKeys: String, CodingKey {
    case userID = "userId"
    case accessToken = "accessToken"
    case refreshToken = "refreshToken"
    case providerToken = "provider_accessToken"
  }
}
