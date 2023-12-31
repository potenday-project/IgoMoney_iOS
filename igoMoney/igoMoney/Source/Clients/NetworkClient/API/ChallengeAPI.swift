//
//  ChallengeAPI.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

struct ChallengeAPI: RequestGenerator {
  var baseURL: String = "http://223.130.133.71:8080"
  var method: HTTPMethod
  var path: String
  var query: [String : String]
  var header: [String : Any]
  var body: HTTPBody?
}
