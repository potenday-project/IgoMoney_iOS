//
//  Date + Extensions.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

extension Date {
  
  static let formatter = DateFormatter()
  
  static func ==(lhs: Self, rhs: Self) -> Bool {
    return lhs.toString(with: "yy.MM.dd") == rhs.toString(with: "yy.MM.dd")
  }
  
  func toString(with format: String) -> String {
    let formatter = Self.formatter
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.dateFormat = format
    return formatter.string(from: self)
  }
  
  func calculateDate(to targetDate: Date) -> Int {
    let calendar = Calendar.current
    let component = calendar.dateComponents([.day], from: self, to: targetDate)
    return abs(component.day ?? .zero)
  }
}

extension String {
  func toDate(with format: String) -> Date? {
    let formatter = Date.formatter
    formatter.dateFormat = format
    return formatter.date(from: self)
  }
}
