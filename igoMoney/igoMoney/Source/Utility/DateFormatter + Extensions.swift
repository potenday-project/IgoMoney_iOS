//
//  DateFormatter + Extension.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

extension DateFormatter {
  static let `default`: DateFormatter = {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    formatter.timeZone = .current
    return formatter
  }()
}

extension JSONDecoder {
  static let `default`: JSONDecoder = {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .formatted(.default)
    return decoder
  }()
}
