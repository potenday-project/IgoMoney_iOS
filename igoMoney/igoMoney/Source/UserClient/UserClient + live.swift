//
//  UserClient + live.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

import ComposableArchitecture

struct AuthToken: Codable, Equatable {
  let accessToken: String
  let expiresAt: String
  let idToken: String
  let refreshToken: String
  let tokenType: String
  let createdAt: Date = Date()
  
  var isExpired: Bool {
    return createdAt.addingTimeInterval(TimeInterval(expiresAt) ?? 0) < Date().addingTimeInterval(86400)
  }
  
  enum CodingKeys: String, CodingKey {
    case accessToken = "access_token"
    case expiresAt = "expires_in"
    case idToken = "id_token"
    case refreshToken = "refresh_token"
    case tokenType = "token_type"
  }
  
  static let failureDefault: Self = .init(accessToken: "", expiresAt: "0", idToken: "", refreshToken: "", tokenType: "bearer")
  static let successDefault: Self = .init(accessToken: "", expiresAt: "3600", idToken: "", refreshToken: "", tokenType: "bearer")
}

extension UserClient {
  static var liveValue: UserClient = {
    @Dependency(\.apiClient) var apiClient
    
    return Self { token in
      return true
    } signInApple: { user, idToken, authCode in
      guard let data = ["id_token": idToken, "code": authCode].toJsonString()?.data(using: .utf8) else {
        throw APIError.badRequest(400)
      }
      
      let api = AuthAPI(
        method: .post,
        path: "/auth/login/apple/redirect",
        query: [:],
        header: ["Content-Type": "application/json"],
        body: .json(value: data)
      )
      
      let response: AuthToken = try await apiClient.request(to: api)
      KeyChainClient.saveIdentifier(identifier: user)
      KeyChainClient.create(authToken: response)
      return response
    } checkNicknameDuplicate: { nickName in
      return true
    } getUserInformation: { userID in
      let api = AuthAPI(method: .get, path: "/users/\(userID)", query: [:], header: [:], body: nil)
      
      let response: User = try await apiClient.request(to: api)
      return response
    } signOut: {
      return ()
    }
  }()
}
