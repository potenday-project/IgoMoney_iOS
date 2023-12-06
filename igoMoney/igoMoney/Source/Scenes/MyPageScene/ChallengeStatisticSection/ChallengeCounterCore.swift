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
    case onAppear
  }
  
  func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case .onAppear:
      guard let user = APIClient.currentUser else { return .none }
      
      switch state.challengeType {
      case .win:
        state.challengeCount = user.winCount
      case .total:
        state.challengeCount = user.challengeCount
      }
      
      return .none
    }
  }
}
