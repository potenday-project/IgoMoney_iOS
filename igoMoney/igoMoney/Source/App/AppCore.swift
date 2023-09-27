//
//  AppCore.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import ComposableArchitecture

struct AppCore: Reducer {
  enum State {
    case logIn(MainCore.State)
    case logOut(AuthCore.State)
  }
  
  enum Action {
    case mainAction(MainCore.Action)
    case authAction(AuthCore.Action)
  }
  
  var body: some Reducer<State, Action> {
    Scope(state: /State.logIn, action: /Action.mainAction) {
      MainCore()
    }
    
    Scope(state: /State.logOut, action: /Action.authAction) {
      AuthCore()
    }
    
    Reduce { state, action in
      switch action {
      case .authAction(._presentMainScene):
        state = .logIn(MainCore.State())
        return .none
      default:
        return .none
      }
    }
  }
}
