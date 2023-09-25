//
//  UserClient + live.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import ComposableArchitecture

struct AuthToken: Decodable, Equatable {
  let accessToken: String
  let expiresAt: String
  let idToken: String
  let refreshToken: String
  let tokenType: String
  
  enum CodingKeys: String, CodingKey {
    case accessToken = "access_token"
    case expiresAt = "expires_in"
    case idToken = "id_token"
    case refreshToken = "refresh_token"
    case tokenType = "token_type"
  }
}

extension UserClient {
  static var liveValue: UserClient = {
    @Dependency(\.apiClient) var apiClient
    
    return Self { token in
      return true
    } signInApple: { idToken, authCode in
      guard let data = ["id_token": idToken, "code": authCode].toJsonString()?.data(using: .utf8) else {
        throw APIError.badRequest(400)
      }
      
      let api = AuthAPI(body: .json(value: data))
      let response: AuthToken = try await apiClient.request(to: api)
      return response
      
    } checkNicknameDuplicate: { nickName in
      return true
    } getUserInformation: { userID in
      return .default
    } signOut: {
      return ()
    }
  }()
}
