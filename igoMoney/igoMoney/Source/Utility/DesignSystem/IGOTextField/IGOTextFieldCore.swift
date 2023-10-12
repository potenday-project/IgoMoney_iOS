//
//  IGOTextFieldCore.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import ComposableArchitecture

struct TextFieldCore: Reducer {
  struct State: Equatable {
    var textLimit: Int
    var text = ""
  }
  
  enum Action: Equatable {
    case textDidChange(String)
  }
  
  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case let .textDidChange(changedValue):
        if changedValue.count > state.textLimit {
          return .none
        }
        
        state.text = changedValue
        return .none
      }
    }
  }
}
