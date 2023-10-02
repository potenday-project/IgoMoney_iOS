//
//  SettingCore.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import ComposableArchitecture

struct SettingCore: Reducer {
  struct State: Equatable {
    let settings = Setting.allCases
  }
  
  @Dependency(\.userClient) var userClient
  
  enum Action {
    case signOut
    case withdraw
    
    case _withdrawResponse(TaskResult<Bool>)
  }
  
  func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case .signOut:
      return .none
      
    case .withdraw:
      return .run { send in
        await send(
          ._withdrawResponse(
            TaskResult {
              try await userClient.withdraw()
            }
          )
        )
      }
      
    case ._withdrawResponse(.success):
      print("Success Withdraw")
      return .none
      
    case ._withdrawResponse(.failure):
      print("Failure Withdraw")
      return .none
    }
  }
}
