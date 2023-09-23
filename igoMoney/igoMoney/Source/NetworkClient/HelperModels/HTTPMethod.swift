//
//  HTTPMethod.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

enum HTTPMethod {
  case get
  case post
  case update
  case delete
  
  var stringValue: String {
    switch self {
    case .get:      return "GET"
    case .post:     return "POST"
    case .update:   return "UPDATE"
    case .delete:   return "DELETE"
    }
  }
}
