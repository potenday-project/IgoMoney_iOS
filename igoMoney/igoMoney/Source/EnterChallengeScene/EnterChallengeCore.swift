//
//  EnterChallengeCore.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import ComposableArchitecture

struct EnterChallengeCore: Reducer {
  struct State: Equatable {
    let challenge: ChallengeInformation
    var showAlert: Bool = false
  }
  
  enum Action: Equatable {
    // User Action
    case enterChallenge
    case setShowAlert(Bool)
    
    // Inner Action
    
  }
  
  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .enterChallenge:
        // TODO: - 사용자 입장 메서드 수행
        return .run { send in
          await send(.setShowAlert(false))
        }
        
      case .setShowAlert(true):
        state.showAlert = true
        return .none
        
      case .setShowAlert(false):
        state.showAlert = false
        return .none
      }
    }
  }
}
