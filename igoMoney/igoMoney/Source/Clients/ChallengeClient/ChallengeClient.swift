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

struct ChallengeClient {
  var getMyChallenge: @Sendable () async throws -> Challenge
  var fetchNotStartedChallenge: @Sendable () async throws -> [Challenge]
  var enterChallenge: @Sendable (_ challengeID: String) async throws -> Bool
  var generateChallenge: @Sendable (_ challenge: ChallengeGenerateRequest) async throws -> [String: Int]
}

extension ChallengeClient: DependencyKey { }

extension DependencyValues {
  var challengeClient: ChallengeClient {
    get { self[ChallengeClient.self] }
    set { self[ChallengeClient.self] = newValue }
  }
}
