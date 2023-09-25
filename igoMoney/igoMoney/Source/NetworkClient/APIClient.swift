//
//  APIClient.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

import ComposableArchitecture

struct APIClient: Networking {
  func request<T>(to generator: RequestGenerator) async throws -> T where T : Decodable {
    do {
      let request = try generator.generate()
      let (data, _) = try await URLSession.shared.data(for: request)
      return try JSONDecoder().decode(T.self, from: data)
    } catch {
      print("Error in API Client \(error)")
      throw error
    }
  }
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
