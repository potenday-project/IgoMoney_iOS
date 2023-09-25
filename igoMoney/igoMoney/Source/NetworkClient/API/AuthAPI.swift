//
//  AuthAPI.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

struct AuthAPI: RequestGenerator {
  var baseURL: String = "http://223.130.133.71:8080"
  var method: HTTPMethod = .post
  var path: String = "/auth/login/apple/redirect"
  var query: [String : Any] = [:]
  var header: [String : Any] = ["Content-Type": "application/json"]
  var body: HTTPBody
  
  init(body: HTTPBody) {
    self.body = body
  }
}
