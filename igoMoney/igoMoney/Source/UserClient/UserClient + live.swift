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
      let api = AuthAPI(
        method: .get,
        path: "/users/nickname/\(nickName)",
        query: [:],
        header: [:]
      )
      return try await apiClient.execute(to: api)
        .data
        .base64EncodedString()
        .isEmpty
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
      
      return try await apiClient.execute(to: api)
        .data
        .base64EncodedString()
        .isEmpty
      
    } getUserInformation: { userID in
      let api = AuthAPI(method: .get, path: "/users/\(userID)", query: [:], header: [:], body: nil)
      
      let response: User = try await apiClient.request(to: api)
      return response
    } signOut: {
      return ()
    } withdraw: {
      guard let token = KeyChainClient.read() else {
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
      
      return try await apiClient.execute(to: api)
        .data
        .isEmpty
    }
  }()
}
