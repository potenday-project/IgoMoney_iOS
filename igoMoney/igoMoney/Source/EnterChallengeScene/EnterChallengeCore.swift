//
//  EnterChallengeCore.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import ComposableArchitecture

struct EnterChallengeCore: Reducer {
  struct State: Equatable {
    let challenge: ChallengeInformation
  }
  
  enum Action: Equatable {
    
  }
  
  func reduce(into state: inout State, action: Action) -> Effect<Action> {
    return .none
  }
}
