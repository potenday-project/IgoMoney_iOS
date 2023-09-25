//
//  UserClient + live.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import ComposableArchitecture

extension UserClient {
  static var liveValue: UserClient = {
    @Dependency(\.apiClient) var apiClient
    
    return Self.init { token in
      return true
    } signInApple: { idToken, authCode in
      return true
    } checkNicknameDuplicate: { nickName in
      return true
    } getUserInformation: { userID in
      return .default
    } signOut: {
      return ()
    }
  }()
}
