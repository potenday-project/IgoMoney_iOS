//
//  UserClient.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

import ComposableArchitecture

struct UserClient {
  var checkNicknameDuplicate: @Sendable (_ nickName: String) async throws -> Bool
  var updateUserInformation: @Sendable (_ nickName: String?, _ profileImage: Data?) async throws -> Bool
  var getUserInformation: @Sendable (_ userID: String?) async throws -> User
}

extension UserClient: DependencyKey { }

extension DependencyValues {
  var userClient: UserClient {
    get { self[UserClient.self] }
    set { self[UserClient.self] = newValue }
  }
}
