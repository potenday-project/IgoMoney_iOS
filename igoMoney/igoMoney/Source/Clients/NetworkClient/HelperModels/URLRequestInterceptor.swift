//
//  URLRequestInterceptor.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

enum RequestRetry {
  case retry
  case doNotRetry
}

protocol URLRequestInterceptor {
  var retryCount: Int { get }
  func adapt(_ request: URLRequest) throws -> URLRequest
  func retry() async throws -> RequestRetry
}

class AuthInterceptor: URLRequestInterceptor {
  var retryCount: Int = 0
  
  func adapt(_ request: URLRequest) throws -> URLRequest {
    var request = request
    
    if request.description.hasPrefix("https://igomoney") == true || request.description.contains("auth") {
      return request
    }
    
    let tokenData = try KeyChainClient.read(.token, SystemConfigConstants.tokenService)
    
    if let authToken: AuthToken = tokenData.toDecodable() {
      if authToken.isExpired {
        throw APIError.tokenExpired
      }
      
      request.addValue("Bearer \(authToken.accessToken)", forHTTPHeaderField: "Authorization")
    }
    
    return request
  }
  
  func retry() async throws -> RequestRetry {
    if retryCount == 3 {
      return .doNotRetry
    }
    
    let tokenData = try? KeyChainClient.read(.token, SystemConfigConstants.tokenService)
    guard let token: AuthToken = tokenData?.toDecodable() else {
      return .doNotRetry
    }
    
    let refreshRequest = try AuthAPI(
      method: .post,
      path: "/auth/refresh-token",
      query: [:],
      header: ["Content-Type": "application/json"],
      body: .json(value: ["refreshToken": token.refreshToken])
    ).generate()
    
    let (data, _) = try await URLSession.shared.data(for: refreshRequest)
    
    if let token: AuthToken = data.toDecodable() {
      try KeyChainClient.save(token.encodeData)
    }
    
    self.retryCount += 1
    
    return .retry
  }
}
