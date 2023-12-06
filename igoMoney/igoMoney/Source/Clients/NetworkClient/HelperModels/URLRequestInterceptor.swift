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
  func adapt(_ request: URLRequest) throws -> URLRequest
  func retry(_ request: URLRequest, statusCode: Int) async throws -> RequestRetry
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
  
  func retry(_ request: URLRequest, statusCode: Int) async throws -> RequestRetry {
    if retryCount == 3 {
      return .doNotRetry
    }
    
    if statusCode == 401 {
      let token = try await AuthClient.liveValue.refreshToken()
      try KeyChainClient.save(token.encodeData)
      self.retryCount += 1
      return .retry
    }
    
    return .doNotRetry
  }
}
