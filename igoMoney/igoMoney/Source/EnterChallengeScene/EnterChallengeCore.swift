//
//  EnterChallengeCore.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import ComposableArchitecture

struct EnterChallengeCore: Reducer {
  struct State: Equatable {
    let challenge: Challenge
    var showAlert: Bool = false
    var showProgressView: Bool = false
    
    var isBeingDismiss: Bool = false
  }
  
  enum Action: Equatable {
    // User Action
    case enterChallenge
    case dismiss
    case setShowAlert(Bool)
    
    // Inner Action
    case _closeAlert
  }
  
  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .enterChallenge:
        // TODO: - 사용자 입장 메서드 수행
        state.showProgressView = true
        return .run { send in
          await send(._closeAlert)
        }
        
      case .dismiss:
        return .none
        
      case .setShowAlert(true):
        state.showAlert = true
        return .none
        
      case .setShowAlert(false):
        state.showAlert = false
        return .none
        
      case ._closeAlert:
        state.showAlert = false
        return .none
      }
    }
  }
}
