//
//  HTTPBody.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

enum HTTPBody {
  case json(value: Data)
  case multipart(values: [String: Any])
  
  var data: Data {
    switch self {
    case .json(let value):
      return value
    case .multipart(let values):
      // Multipart Generator
      return Data()
    }
  }
}
