//
//  ChallengeClient + live.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import Dependencies

extension ChallengeClient {
  static var liveValue: ChallengeClient {
    return self.init(getMyChallenge: { _ in
      return .default
    })
  }
}
