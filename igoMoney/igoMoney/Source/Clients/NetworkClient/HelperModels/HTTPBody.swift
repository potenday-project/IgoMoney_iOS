//
//  HTTPBody.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

enum HTTPBody {
  case json(value: [String: String])
  case multipart(boundary: String, values: [MultipartForm.FormKey: MultipartForm.FormData])
  case urlEncoded(value: [String: String])
  
  var data: Data? {
    switch self {
    case .json(let value):
      guard let data = try? JSONEncoder().encode(value) else {
        return Data()
      }
      return data
      
    case .multipart(let boundary, let values):
      return MultipartForm(boundary: boundary, values: values)
        .httpBody()
      
    case let .urlEncoded(values):
      let formDataString = values
        .map { "\($0)=\($1)" }
        .map { String($0) }
        .joined(separator: "&")
      return formDataString.data(using: .utf8)
    }
  }
}
