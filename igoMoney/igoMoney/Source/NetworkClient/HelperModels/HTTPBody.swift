//
//  HTTPBody.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

enum HTTPBody {
  case json(value: Data)
  case multipart(boundary: String, values: [String: String])
  
  var data: Data {
    switch self {
    case .json(let value):
      return value
    case .multipart(let boundary, let values):
      return MultipartForm(boundary: boundary, values: values)
        .httpBody()
    }
  }
}
