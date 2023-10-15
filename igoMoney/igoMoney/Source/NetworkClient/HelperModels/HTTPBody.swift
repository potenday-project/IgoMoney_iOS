//
//  HTTPBody.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

enum HTTPBody {
  case json(value: Data)
  case multipart(boundary: String, values: [String: String])
  case urlEncoded(value: [String: String])
  
  var data: Data? {
    switch self {
    case .json(let value):
      return value
    case .multipart(let boundary, let values):
      return MultipartForm(boundary: boundary, values: values)
        .httpBody()
      
    case let .urlEncoded(values):
      let formDataString = values
        .flatMap { "\($0)=\($1)" }
        .map { String($0) }
        .joined(separator: "&")
      return formDataString.data(using: .utf8)
    }
  }
}
