//
//  APIClient.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

import ComposableArchitecture

struct APIClient: Networking {
  static var currentUser: User? = nil
  func request<T>(to generator: RequestGenerator) async throws -> T where T : Decodable {
    do {
      let request = try generator.generate()
      let (data, response) = try await URLSession.shared.data(for: request)
      
      guard let response = response as? HTTPURLResponse else {
        throw APIError.invalidResponse
      }
      
      do {
        let _ = try checkResponse(with: response)
      } catch {
        throw error
      }
      
      return try JSONDecoder().decode(T.self, from: data)
    } catch {
      print("Error in API Client \(error)")
      throw error
    }
  }
  
  private func checkResponse(with response: HTTPURLResponse) throws -> Void {
    let statusCode = response.statusCode
    switch statusCode {
    case 100..<200:
      throw APIError.informationResponse
    case 200..<300:
      return
    case 300..<400:
      throw APIError.redirect
    case 400..<500:
      throw APIError.badRequest(statusCode)
    case 500...:
      throw APIError.invalidServer(statusCode)
    default:
      throw APIError.badRequest(statusCode)
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
