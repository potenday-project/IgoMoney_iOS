//
//  APIClient.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

import ComposableArchitecture

struct APIClient: Networking {
  static var currentUser: User? = nil
}

extension APIClient: DependencyKey {
  static var liveValue: APIClient = APIClient()
}

extension DependencyValues {
  var apiClient: APIClient {
    get { self[APIClient.self] }
    set { self[APIClient.self] = newValue }
  }
}
