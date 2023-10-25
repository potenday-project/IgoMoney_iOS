//
//  SettingCore.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import ComposableArchitecture

struct GeneralSettingCore: Reducer {
  struct State: Equatable {
    let settings = Setting.allCases
  }
  
  
  enum Action {
    case signOut
    case withdraw
    
    case _removeTokenResponse(TaskResult<Void>)
    case _removeUserIdentifierResponse(TaskResult<Void>)
    case _withdrawResponse(TaskResult<Void>)
  }
  
  @Dependency(\.authClient) var authClient
  
  func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case .signOut:
      return .run { send in
        await send(
          ._removeTokenResponse(
            TaskResult {
              try KeyChainClient.delete(.token, SystemConfigConstants.tokenService)
            }
          )
        )
      }
      
    case .withdraw:
      return .run { send in
        await send(
          ._withdrawResponse(
            TaskResult {
              try await authClient.withdraw()
            }
          )
        )
      }
      
    case ._withdrawResponse(.success):
      return .concatenate(
        .run { send in
          await send(
            ._removeTokenResponse(
              TaskResult {
                try KeyChainClient.delete(.token, SystemConfigConstants.tokenService)
              }
            )
          )
        },
        .run { send in
          await send(
            ._removeUserIdentifierResponse(
              TaskResult {
                try KeyChainClient.delete(.userIdentifier, SystemConfigConstants.userIdentifierService)
              }
            )
          )
        }
      )
      
    case ._withdrawResponse(.failure):
      print("Failure Withdraw")
      return .none
      
    case ._removeTokenResponse, ._removeUserIdentifierResponse:
      return .none
      
    }
  }
}
