//
//  ChallengeClient.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

import Dependencies

struct ChallengeClient {
  var getMyChallenge: @Sendable () async throws -> Challenge
  var fetchNotStartedChallenge: @Sendable () async throws -> [Challenge]
}

extension ChallengeClient: DependencyKey { }

extension DependencyValues {
  var challengeClient: ChallengeClient {
    get { self[ChallengeClient.self] }
    set { self[ChallengeClient.self] = newValue }
  }
}
