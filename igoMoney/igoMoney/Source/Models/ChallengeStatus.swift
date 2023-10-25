//
//  ChallengeStatus.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

enum ChallengeStatus: Equatable {
  case processingChallenge(Challenge)
  case waitingUser(Challenge)
  case waitingStart(Challenge)
  case notInChallenge
}
