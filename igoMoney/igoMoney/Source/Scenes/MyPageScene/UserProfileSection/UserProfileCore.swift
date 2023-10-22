//
//  UserProfileSectionCore.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import ComposableArchitecture

struct UserProfileCore: Reducer {
  struct State: Equatable {
    var profilePath: String = ""
    var userName: String = ""
    var challengeState: ChallengeStatus = .notInChallenge
  }
  
  enum Action: Equatable {
    
  }
  
  func reduce(into state: inout State, action: Action) -> Effect<Action> {
    return .none
  }
}
