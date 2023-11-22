//
//  AuthClient + live.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import FirebaseMessaging

extension AuthClient {
  static var liveValue = AuthClient { token in
    let fcmToken = try await Messaging.messaging().token()
    
    let api = AuthAPI(
      method: .post,
      path: "/auth/login/kakao",
      query: [:],
      header: ["Content-Type": "application/json"],
      body: .json(value: ["accessToken": token, "fcmToken": fcmToken])
    )
    
    var response: AuthToken = try await APIClient.request(to: api)
    response.provider = .kakao
    
    try KeyChainClient.save(response.encodeData)
    
    return response
  } signInWithApple: { user, idToken, authCode in
    let fcmToken = try await Messaging.messaging().token()

    let body = ["id_token": idToken, "code": authCode, "fcmToken": fcmToken]
    
    let api = AuthAPI(
      method: .post,
      path: "/auth/login/apple/redirect",
      query: [:],
      header: ["Content-Type": "application/json"],
      body: .json(value: body)
    )
    
    var response: AuthToken = try await APIClient.request(to: api)
    response.provider = .apple
    
    try KeyChainClient.save(response.encodeData)
    try KeyChainClient.save(
      user.data(using: .utf8),
      .userIdentifier,
      SystemConfigConstants.userIdentifierService
    )
    
    return response
  } refreshToken: {
    let tokenData = try KeyChainClient.read(.token, SystemConfigConstants.tokenService)
    
    guard let currentToken: AuthToken = tokenData.toDecodable() else {
      throw APIError.badRequest(400)
    }
    
    let api = AuthAPI(
      method: .post,
      path: "/auth/refresh_token",
      query: [:],
      header: ["Content-Type": "application/json"],
      body: .json(
        value: [
          "Authorization": "Bearer \(currentToken.refreshToken)"
        ]
      )
    )
    
    let response: AuthToken = try await APIClient.request(to: api)
    return response
  } signOut: {
    try KeyChainClient.delete(.token, SystemConfigConstants.tokenService)
    try KeyChainClient.delete(.userIdentifier, SystemConfigConstants.userIdentifierService)
    
    return true
  } withdraw: {
    let tokenData = try KeyChainClient.read(.token, SystemConfigConstants.tokenService)
    guard let token: AuthToken = tokenData.toDecodable() else {
      throw APIError.badRequest(400)
    }
    
    let api = generateWithdrawAPI(with: token)
    let response = try await APIClient.execute(to: api)
    
    return true
  }
}

private func generateWithdrawAPI(with token: AuthToken) -> AuthAPI {
  switch token.provider {
  case .apple:
    let api = AuthAPI(
      method: .post,
      path: "/auth/signout/apple/",
      query: [:],
      header: ["Content-Type": "application/json"],
      body: .json(
        value: [
          "userId": token.userID.description,
          "code": token.accessToken
        ]
      )
    )
    return api
    
  case .kakao:
    let api = AuthAPI(
      method: .post,
      path: "/auth/signout/kakao/\(token.userID.description)",
      query: [:],
      header: [:]
    )
    return api
  default:
    return AuthAPI(method: .post, path: "", query: [:], header: [:])
  }
}

