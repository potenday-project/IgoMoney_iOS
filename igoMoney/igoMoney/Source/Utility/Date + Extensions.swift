//
//  Date + Extensions.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

extension Date {
  
  static let formatter = DateFormatter()
  
  func toString(with format: String) -> String {
    let formatter = Self.formatter
    formatter.dateFormat = format
    return formatter.string(from: self)
  }
}
