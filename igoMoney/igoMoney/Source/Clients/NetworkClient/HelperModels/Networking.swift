//
//  Networking.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

import Dependencies

protocol Networking {
  static func request<T: Decodable>(to generator: RequestGenerator) async throws -> T
  static func execute(to generator: RequestGenerator) async throws -> Data
}

extension Networking {
  static func execute(to generator: RequestGenerator) async throws -> Data {
    var request = try generator.generate()
    
    let tokenData = try? KeyChainClient.read(.token, SystemConfigConstants.tokenService)
    
    if let authToken: AuthToken = tokenData?.toDecodable() {
      if authToken.isExpired {
        throw APIError.tokenExpired
      }
      request.addValue("Bearer \(authToken.accessToken)", forHTTPHeaderField: "Authorization")
    }
    
    let (data, response) = try await URLSession.shared.data(for: request)
    
    try handleResponse(response: response)
    
    return data
  }
  
  static func request<T: Decodable>(to generator: RequestGenerator) async throws -> T {
    let data = try await execute(to: generator)
    guard let decodeData = try? JSONDecoder().decode(T.self, from: data) else {
      throw APIError.couldNotConvertJson
    }
    
    return decodeData
  }
  
  private static func handleResponse(response: URLResponse) throws {
    guard let response = response as? HTTPURLResponse else {
      throw APIError.invalidResponse
    }
    
    try handleStatusCode(with: response.statusCode)
  }
  
  private static func handleStatusCode(with code: Int) throws {
    switch code {
    case (100..<200):
      throw APIError.informationResponse
    case (200..<300):
      break
    case (300..<400):
      throw APIError.redirect
    case (400..<500):
      throw APIError.badRequest(code)
    case (500...):
      throw APIError.invalidServer(code)
      
    default: throw APIError.badRequest(.zero)
    }
  }
}