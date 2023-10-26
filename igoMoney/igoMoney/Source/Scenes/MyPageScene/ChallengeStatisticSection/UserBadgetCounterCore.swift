//
//  UserBadgetCounterCore.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import ComposableArchitecture

struct UserBadgeCounterCore: Reducer {
  struct State: Equatable {
    var badgeCount: Int
  }
  
  enum Action: Equatable {
    
  }
  
  func reduce(into state: inout State, action: Action) -> Effect<Action> {
    return .none
  }
}
