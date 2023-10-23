//
//  ProfileEditCore.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import ComposableArchitecture

struct ProfileEditCore: Reducer {
  struct State: Equatable {
    let profileImageState: URLImageCore.State
    let nickNameState: NickNameCheckDuplicateCore.State
  }
  
  enum Action: Equatable {
    
  }
  
  func reduce(into state: inout State, action: Action) -> Effect<Action> {
    return .none
  }
}
