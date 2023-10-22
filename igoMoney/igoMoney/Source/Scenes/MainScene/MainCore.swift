//
//  MainCore.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import ComposableArchitecture

struct MainCore: Reducer {
  struct State: Equatable {
    var selectedTab: MainTab = .home
    
    var challengeState = HomeCore.State()
    var myPageState = MyPageCore.State()
  }
  
  enum Action {
    case selectedTabChange(MainTab)
    
    // Child Action
    case challengeAction(HomeCore.Action)
    case myPageAction(MyPageCore.Action)
  }
  
  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .selectedTabChange(let tab):
        state.selectedTab = tab
        return .none
        // Child Action
      case .challengeAction:
        return .none
        
      case .myPageAction:
        return .none
      }
    }
    
    Scope(state: \.challengeState, action: /Action.challengeAction) {
      HomeCore()
    }
    
    Scope(state: \.myPageState, action: /Action.myPageAction) {
      MyPageCore()
        ._printChanges()
    }
  }
}
