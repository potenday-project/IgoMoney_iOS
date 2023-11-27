//
//  RequestGenerator.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

protocol RequestGenerator {
  var baseURL: String { get }
  var method: HTTPMethod { get }
  var path: String { get }
  var query: [String: String] { get }
  var header: [String: Any] { get }
  var body: HTTPBody? { get }
}

extension RequestGenerator {
  func generate() throws -> URLRequest {
    var component = URLComponents(string: baseURL)
    component?.path = path
    component?.queryItems = query.map { URLQueryItem(name: $0.key, value: $0.value) }
    
    guard let url = try? component?.asURL() else {
      throw APIError.didNotConvertRequest
    }
    var request = URLRequest(url: url)
    header.forEach {
      request.setValue($0.value as? String, forHTTPHeaderField: $0.key)
    }
    request.httpMethod = method.stringValue
    request.httpBody = body?.data
    return request
  }
}
