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
  
  enum CodingKeys: String, CodingKey {
    case userID = "userId"
    case totalCost = "totalCost"
  }
}

struct ChallengeClient {
  var getMyChallenge: @Sendable () async throws -> Challenge
  var fetchNotStartedChallenge: @Sendable (
    _ lastID: Int?,
    _ filterCategory: Int?,
    _ filterMoney: Int?
  ) async throws -> [Challenge]
  var enterChallenge: @Sendable (_ challengeID: String) async throws -> Bool
  var generateChallenge: @Sendable (_ challenge: ChallengeGenerateRequest) async throws -> [String: Int]
  var challengeCosts: @Sendable (_ challenge: Challenge, _ isMine: Bool) async throws -> ChallengeCostResponse
  var giveUpChallenge: @Sendable () async throws -> Data
}

extension ChallengeClient: DependencyKey { }

extension DependencyValues {
  var challengeClient: ChallengeClient {
    get { self[ChallengeClient.self] }
    set { self[ChallengeClient.self] = newValue }
  }
}
