//
//  ChallengeClient + live.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import Dependencies

extension ChallengeClient {
  static var liveValue: ChallengeClient = {
    @Dependency(\.apiClient) var apiClient
    
    return Self { userID in
      let requestGenerator = ChallengeAPI(
        method: .get,
        path: "/challenges/my-active-challenge/\(userID)",
        query: [:],
        header: [:]
      )
      
      let response: Challenge = try await apiClient.request(to: requestGenerator)
      return response
    }
  }()
}
