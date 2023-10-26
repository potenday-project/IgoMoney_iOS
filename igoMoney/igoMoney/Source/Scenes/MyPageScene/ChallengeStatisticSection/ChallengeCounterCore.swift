//
//  ChallengeCounterCore.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import ComposableArchitecture

struct ChallengeCounterCore: Reducer {
  struct State: Equatable {
    var challengeCount: Int = .zero
    let challengeType: ChallengeCounterType
  }
  
  enum Action {
    
  }
  
  func reduce(into state: inout State, action: Action) -> Effect<Action> {
    return .none
  }
}
