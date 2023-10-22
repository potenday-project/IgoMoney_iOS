//
//  MyPageCore.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import ComposableArchitecture

struct MyPageCore: Reducer {
  struct State: Equatable {
    var settingState = SettingCore.State()
    var profileState = UserProfileCore.State()
  }
  
  enum Action {
    case settingAction(SettingCore.Action)
    case userProfileAction(UserProfileCore.Action)
  }
  
  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .userProfileAction:
        return .none
        
      default:
        return .none
      }
    }
    
    Scope(state: \.settingState, action: /Action.settingAction) {
      SettingCore()
    }
  }
}
