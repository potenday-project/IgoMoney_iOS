//
//  Setting.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

enum Setting: Int, CaseIterable {
  case version
  case logOut
  case withdraw
  
  var description: String {
    switch self {
    case .version:  return "버전"
    case .logOut:   return "로그아웃"
    case .withdraw: return "탈퇴하기"
    }
  }
  
  var color: Color {
    if self == .withdraw { return ColorConstants.warning }
    return .black
  }
}
