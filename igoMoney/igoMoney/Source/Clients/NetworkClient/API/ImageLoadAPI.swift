//
//  ImageLoadAPI.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

struct ImageLoadAPI: RequestGenerator {
  var baseURL: String
  var method: HTTPMethod
  var path: String = ""
  var query: [String : Any] = [:]
  var header: [String : Any] = [:]
  var body: HTTPBody? = nil
}

extension ImageLoadAPI {
  func generateRequest() throws -> URLRequest {
    guard let url = URL(string: baseURL) else {
      throw APIError.badRequest(400)
    }
    
    return URLRequest(url: url)
  }
}
