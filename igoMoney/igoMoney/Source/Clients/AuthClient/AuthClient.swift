//
//  AuthClient.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import Dependencies

struct AuthClient {
  var signInWithKakao: @Sendable (_ token: String) async throws -> AuthToken
  var signInWithApple: @Sendable (_ user: String, _ idToken: String, _ authCode: String) async throws -> AuthToken
  var refreshToken: @Sendable () async throws -> AuthToken
  var signOut: @Sendable () throws -> Bool
  var withdraw: @Sendable () async throws -> Bool
}

extension AuthClient: DependencyKey { }

extension DependencyValues {
  var authClient: AuthClient {
    get { self[AuthClient.self] }
    set { self[AuthClient.self] = newValue }
  }
}
