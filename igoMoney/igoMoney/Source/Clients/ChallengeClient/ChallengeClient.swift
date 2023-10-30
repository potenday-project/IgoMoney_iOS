//
//  ChallengeClient.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

import Dependencies

struct ChallengeGenerateRequest {
  let userID: Int
  let title: String
  let content: String
  let targetAmount: Int
  let categoryID: Int
  let startDate: String
  
  func toDictionary() -> [String: String] {
    return [
      "userId": userID.description,
      "title": title,
      "content": content,
      "categoryId": categoryID.description,
      "targetAmount": targetAmount.description,
      "startDate": startDate
    ]
  }
}

struct ChallengeCostResponse: Decodable, Equatable {
  let userID: Int
  let totalCost: Int
  var fetchUserID: Int
  
  enum CodingKeys: String, CodingKey {
    case userID = "userId"
    case totalCost = "totalCost"
  }
  
  init(userID: Int, totalCost: Int, fetchUserID: Int) {
    self.userID = userID
    self.totalCost = totalCost
    self.fetchUserID = fetchUserID
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.userID = try container.decode(Int.self, forKey: .userID)
    self.totalCost = try container.decode(Int.self, forKey: .totalCost)
    self.fetchUserID = userID
  }
  
  static func empty(userID: Int, fetchUserID: Int) -> Self {
    return .init(userID: userID, totalCost: .zero, fetchUserID: fetchUserID)
  }
}

struct ChallengeClient {
  var getMyChallenge: @Sendable () async throws -> Challenge
  var fetchNotStartedChallenge: @Sendable () async throws -> [Challenge]
  var enterChallenge: @Sendable (_ challengeID: String) async throws -> Bool
  var generateChallenge: @Sendable (_ challenge: ChallengeGenerateRequest) async throws -> [String: Int]
  var challengeCosts: @Sendable (_ challengeID: Challenge) async throws -> [ChallengeCostResponse]
}

extension ChallengeClient: DependencyKey { }

extension DependencyValues {
  var challengeClient: ChallengeClient {
    get { self[ChallengeClient.self] }
    set { self[ChallengeClient.self] = newValue }
  }
}
