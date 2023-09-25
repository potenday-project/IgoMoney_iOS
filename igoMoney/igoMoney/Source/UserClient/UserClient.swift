//
//  UserClient.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import ComposableArchitecture

struct UserClient {
  var signInKakao: @Sendable (_ token: String) async -> Bool
  var signInApple: @Sendable (_ idToken: String, _ authCode: String) async -> Bool
  // TODO: - Refresh Token Method 구현
  var checkNicknameDuplicate: @Sendable (_ nickName: String) async -> Bool
  var getUserInformation: @Sendable (_ userID: String) async -> User
  var signOut: @Sendable () -> Void
}

extension UserClient: DependencyKey { }

extension DependencyValues {
  var userClient: UserClient {
    get { self[UserClient.self] }
    set { self[UserClient.self] = newValue }
  }
}
