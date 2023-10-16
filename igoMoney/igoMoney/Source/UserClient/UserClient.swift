//
//  UserClient.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import ComposableArchitecture

struct UserClient {
  var signInKakao: @Sendable (_ token: String) async throws -> AuthToken
  var signInApple: @Sendable (_ user: String, _ idToken: String, _ authCode: String) async throws -> AuthToken
  // TODO: - Refresh Token Method 구현
  var checkNicknameDuplicate: @Sendable (_ nickName: String) async throws -> Bool
  var updateUserInformation: @Sendable (_ userID: String, _ nickName: String) async throws -> Bool
  var getUserInformation: @Sendable (_ userID: String) async throws -> User
  var signOut: @Sendable () -> Void
  var withdraw: @Sendable () async throws -> Bool
}

extension UserClient: DependencyKey { }

extension DependencyValues {
  var userClient: UserClient {
    get { self[UserClient.self] }
    set { self[UserClient.self] = newValue }
  }
}
