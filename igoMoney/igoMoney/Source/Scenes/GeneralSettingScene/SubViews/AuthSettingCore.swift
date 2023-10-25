//
//  AuthSettingCore.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import ComposableArchitecture

struct AuthSettingCore: Reducer {
  struct State: Equatable {
    var token: AuthToken?
    var userEmail: String?
    
    var showSignOutSheet: Bool = false
    var showWithdrawSheet: Bool = false
  }
  
  enum Action {
    case onAppear
    case showSignOut(Bool)
    case showWithdraw(Bool)
    case signOut
    case withdraw
    
    case _fetchToken
    case _fetchUserInformation
    
    case _fetchTokenResponse(TaskResult<AuthToken>)
    case _fetchUserInformationResponse(TaskResult<User>)
    case _signOutResponse(TaskResult<Bool>)
    case _withdrawResponse(TaskResult<Bool>)
    case _removeTokenResult(TaskResult<Void>)
    case _removeUserIdentifierResult(TaskResult<Void>)
  }
  
  @Dependency(\.authClient) var authClient
  @Dependency(\.userClient) var userClient
  
  func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case .onAppear:
      return .concatenate(
        .send(._fetchToken),
        .send(._fetchUserInformation)
      )
      
    case .showSignOut(true):
      state.showSignOutSheet = true
      return .none
      
    case .showSignOut(false):
      state.showSignOutSheet = false
      return .none
      
    case .showWithdraw(true):
      state.showWithdrawSheet = true
      return .none
      
    case .showWithdraw(false):
      state.showWithdrawSheet = false
      return .none
      
    case .signOut:
      return .run { send in
        await send(
          ._signOutResponse(
            TaskResult {
              try authClient.signOut()
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
      
    case ._fetchToken:
      return .run { send in
        await send(
          ._fetchTokenResponse(
            TaskResult {
              try self.fetchCurrentUserToken()
            }
          )
        )
      }
      
    case ._fetchUserInformation:
      return .run { send in
        await send(
          ._fetchUserInformationResponse(
            TaskResult {
              try await userClient.getUserInformation(nil)
            }
          )
        )
      }
      
    case ._fetchTokenResponse(.success(let token)):
      state.token = token
      return .none
      
    case ._fetchUserInformationResponse(.success(let user)):
      state.userEmail = user.email
      return .none
      
    case ._fetchTokenResponse(.failure), ._fetchUserInformationResponse(.failure):
      return .none
      
    case ._withdrawResponse(.success):
      return .concatenate(
        .run { send in
          await send(
            ._removeTokenResult(
              TaskResult {
                try KeyChainClient.delete(.token, SystemConfigConstants.tokenService)
              }
            )
          )
        },
        .run { send in
          await send(
            ._removeUserIdentifierResult(
              TaskResult {
                try KeyChainClient.delete(.userIdentifier, SystemConfigConstants.userIdentifierService)
              }
            )
          )
        }
      )
      
    case ._removeTokenResult, ._removeUserIdentifierResult:
      return .none
      
    case ._signOutResponse, ._withdrawResponse:
      return .none
    }
  }
}

private extension AuthSettingCore {
  func fetchCurrentUserToken() throws -> AuthToken {
    let tokenData = try KeyChainClient.read(.token, SystemConfigConstants.tokenService)
    
    guard let authToken: AuthToken = tokenData.toDecodable() else {
      throw APIError.badRequest(400)
    }
    
    return authToken
  }
}
