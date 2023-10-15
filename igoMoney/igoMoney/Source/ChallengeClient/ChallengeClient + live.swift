//
//  ChallengeClient + live.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import Dependencies

extension ChallengeClient {
  static var liveValue: ChallengeClient = {
    @Dependency(\.apiClient) var apiClient
    
    return Self {
      guard let user = APIClient.currentUser else {
        throw APIError.badRequest(400)
      }
      
      let requestGenerator = ChallengeAPI(
        method: .get,
        path: "/challenges/my-active-challenge/\(user.userID.description)",
        query: [:],
        header: [:]
      )
      
      let response: Challenge = try await apiClient.request(to: requestGenerator)
      return response
    } fetchNotStartedChallenge: {
      let requestGenerator = ChallengeAPI(
        method: .get,
        path: "/challenges/notstarted",
        query: [:],
        header: [:]
      )
      
      let response: [Challenge] = try await apiClient.request(to: requestGenerator)
      return response
    } enterChallenge: { challengeID in
      guard let userID = APIClient.currentUser else {
        throw APIError.badRequest(400)
      }
      
      let requestGenerator = ChallengeAPI(
        method: .post,
        path: "/challenges/apply/\(challengeID)/\(userID.userID.description)",
        query: [:],
        header: [:]
      )
      
      let data = try await apiClient.execute(to: requestGenerator)
      return true
    } generateChallenge: { request in
      let requestGenerator = ChallengeAPI(
        method: .post,
        path: "/challenges/new",
        query: [:],
        header: [
          "Content-Type": "application/x-www-form-urlencoded"
        ],
        body: .urlEncoded(value: request.toDictionary())
      )
      
      let values: [String: Int] = try await apiClient.request(to: requestGenerator)
      return values
    }
  }()
}
