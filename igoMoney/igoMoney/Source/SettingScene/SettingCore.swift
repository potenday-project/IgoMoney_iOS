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
    
    case _removeTokenResponse(TaskResult<Void>)
    case _removeUserIdentifierResponse(TaskResult<Void>)
    case _withdrawResponse(TaskResult<Bool>)
  }
  
  @Dependency(\.keyChainClient) var keyChainClient
  
  func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case .signOut:
      return .run { send in
        await send(
          ._removeTokenResponse(
            TaskResult {
              try await keyChainClient.delete(.token, SystemConfigConstants.tokenService)
            }
          )
        )
      }
      
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
      return .concatenate(
        .run { send in
          await send(
            ._removeTokenResponse(
              TaskResult {
                try await keyChainClient.delete(.token, SystemConfigConstants.tokenService)
              }
            )
          )
        },
        .run { send in
          await send(
            ._removeUserIdentifierResponse(
              TaskResult {
                try await keyChainClient.delete(.userIdentifier, SystemConfigConstants.userIdentifierService)
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
