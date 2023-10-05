//
//  Data + Extensions.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

extension Data {
  func toString(format encoding: String.Encoding = .utf8) -> String {
    guard let decodeValue = String(data: self, encoding: encoding) else {
      return ""
    }
    return decodeValue
  }
  
  func toDecodable<T: Decodable>() -> T? {
    guard let decodeValue = try? JSONDecoder().decode(T.self, from: self) else {
      return nil
    }
    
    return decodeValue
  }
}
