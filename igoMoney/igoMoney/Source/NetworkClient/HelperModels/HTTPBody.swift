//
//  HTTPBody.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

enum HTTPBody {
  case json(value: Data)
  case multipart(values: [String: String])
  
  var data: Data {
    switch self {
    case .json(let value):
      return value
    case .multipart(let values):
      return MultipartForm(values: values).httpBody()
    }
  }
}
