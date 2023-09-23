//
//  Networking.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

protocol Networking {
  func request<T: Decodable>(to generator: RequestGenerator) async throws -> T
}

extension Networking {
  func request<T: Decodable>(to generator: RequestGenerator) async throws -> T {
    guard let request = try? generator.generate() else {
      throw APIError.didNotConvertRequest
    }
    
    let (data, response) = try await URLSession.shared.data(for: request)
    
    guard let response = response as? HTTPURLResponse else {
      throw APIError.invalidResponse
    }
    
    try handleStatusCode(with: response.statusCode)
    
    guard let decodedData = try? JSONDecoder().decode(T.self, from: data) else {
      throw APIError.couldNotConvertJson
    }
    
    return decodedData
  }
  
  private func handleStatusCode(with code: Int) throws {
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
