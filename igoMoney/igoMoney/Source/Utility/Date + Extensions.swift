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
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.dateFormat = format
    return formatter.string(from: self)
  }
}

extension String {
  func toDate(with format: String) -> Date? {
    let formatter = Date.formatter
    formatter.dateFormat = format
    return formatter.date(from: self)
  }
}
