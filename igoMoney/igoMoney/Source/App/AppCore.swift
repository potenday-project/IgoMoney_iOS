//
//  AppCore.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import ComposableArchitecture

struct AppCore: Reducer {
  enum SessionState {
    case auth
    case main
  }
  
  struct State {
    var mainState = MainCore.State()
    var authState = AuthCore.State()
    
    var currentState: SessionState = .auth
  }
  
  enum Action {
    case mainAction(MainCore.Action)
    case authAction(AuthCore.Action)
  }
  
  var body: some Reducer<State, Action> {
    Scope(state: \.mainState, action: /Action.mainAction) {
      MainCore()
    }
    
    Scope(state: \.authState, action: /Action.authAction) {
      AuthCore()
    }
    
    Reduce { state, action in
      switch action {
      case .authAction(._presentMainScene), .authAction(.profileSettingAction(.startChallenge)):
        state.currentState = .main
        return .none
      default:
        return .none
      }
    }
  }
}
