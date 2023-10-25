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
  }
  
  enum Action: Equatable {
    case onAppear
    
    case _fetchToken
    case _fetchUserInformation
    
    case _fetchTokenResponse(TaskResult<AuthToken>)
    case _fetchUserInformationResponse(TaskResult<User>)
  }
  
  @Dependency(\.userClient) var userClient
  
  func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case .onAppear:
      return .concatenate(
        .send(._fetchToken),
        .send(._fetchUserInformation)
      )
      
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
