//
//  SettingCore.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import ComposableArchitecture

struct SettingCore: Reducer {
  struct State {
    let settings = Setting.allCases
  }
  
  enum Action { }
  
  func reduce(into state: inout State, action: Action) -> Effect<Action> {
    return .none
  }
}
