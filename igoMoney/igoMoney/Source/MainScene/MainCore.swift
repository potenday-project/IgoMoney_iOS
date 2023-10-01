//
//  MainCore.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import ComposableArchitecture

struct MainCore: Reducer {
  struct State: Equatable {
    var selectedTab: MainTab = .challenge
    
    var challengeState = ChallengeCore.State()
    var myPageState = MyPageCore.State()
  }
  
  enum Action {
    case selectedTabChange(MainTab)
    
    // Child Action
    case challengeAction(ChallengeCore.Action)
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
      ChallengeCore()
    }
    
    Scope(state: \.myPageState, action: /Action.myPageAction) {
      MyPageCore()
    }
  }
}
