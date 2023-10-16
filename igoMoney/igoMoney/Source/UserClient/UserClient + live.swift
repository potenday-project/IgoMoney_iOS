//
//  UserClient + live.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

import ComposableArchitecture

extension UserClient {
  static var liveValue: UserClient = {
    @Dependency(\.apiClient) var apiClient
    @Dependency(\.keyChainClient) var keyChainClient
    
    return Self { token in
      guard let data = ["accessToken": token].toJsonString()?.data(using: .utf8) else {
        throw APIError.badRequest(400)
      }
      
      let api = AuthAPI(
        method: .post,
        path: "/auth/login/kakao",
        query: [:],
        header: ["Content-Type": "application/json"],
        body: .json(value: data)
      )
      
      let response: AuthToken = try await apiClient.request(to: api)
      
      guard let tokenData = try? JSONEncoder().encode(response) else { throw APIError.badRequest(400) }
      try await keyChainClient.save(tokenData, .token, SystemConfigConstants.tokenService)
      
      return response
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
      guard let tokenData = try? JSONEncoder().encode(response),
            let userData = user.data(using: .utf8) else { throw APIError.badRequest(400) }
      try await keyChainClient.save(userData, .userIdentifier, SystemConfigConstants.userIdentifierService)
      try await keyChainClient.save(tokenData, .token, SystemConfigConstants.tokenService)
      return response
    } refreshToken: {
      let data = try? keyChainClient.read(.token, SystemConfigConstants.tokenService)
      guard let currentToken: AuthToken = data?.toDecodable(),
            let bodyData = ["refreshToken": currentToken.refreshToken].toJsonString()?.data(using: .utf8) else {
        throw APIError.badRequest(400)
      }
      
      let api = AuthAPI(
        method: .post,
        path: "/auth/refresh_token",
        query: [:],
        header: ["Content-Type": "application/json"],
        body: .json(value: bodyData)
      )
      
      let response: AuthToken = try await apiClient.request(to: api)
      return response
    } checkNicknameDuplicate: { nickName in
      let api = AuthAPI(
        method: .get,
        path: "/users/nickname/\(nickName)",
        query: [:],
        header: [:]
      )
      return try await apiClient.execute(to: api).isEmpty
    } updateUserInformation: { id, nickName in
      let boundary = "Boundary_\(UUID().uuidString)"
      let api = AuthAPI(
        method: .patch,
        path: "/users",
        query: [:],
        header: [
          "Content-Type": "multipart/form-data; boundary=\(boundary)"
        ],
        body: .multipart(
          boundary: boundary,
          values: ["id": id, "nickname": nickName]
        )
      )
      
      return try await apiClient.execute(to: api).isEmpty
      
    } getUserInformation: { userID in
      let api = AuthAPI(method: .get, path: "/users/\(userID)", query: [:], header: [:], body: nil)
      
      let response: User = try await apiClient.request(to: api)
      
      if let tokenInformation: AuthToken = try keyChainClient
        .read(.token, SystemConfigConstants.tokenService).toDecodable(),
         tokenInformation.userID == response.userID {
        APIClient.currentUser = response
      }

      return response
    } signOut: {
      return ()
    } withdraw: {
      guard let token: AuthToken = try keyChainClient.read(
        .token,
        SystemConfigConstants.tokenService
      ).toDecodable() else {
        throw APIError.badRequest(400)
      }
      
      guard let tokenData = [
        "userId": token.userID.description,
        "token": token.refreshToken,
        "token_type_hint": "refresh_token"
      ].toJsonString()?.data(using: .utf8) else {
        return false
      }
      
      let api = AuthAPI(
        method: .post,
        path: "/auth/signout/apple",
        query: [:],
        header: ["Content-Type": "application/json"],
        body: .json(value: tokenData)
      )
      
      return try await apiClient.execute(to: api).isEmpty
    }
  }()
}
