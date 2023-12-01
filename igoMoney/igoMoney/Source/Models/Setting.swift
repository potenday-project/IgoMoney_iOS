//
//  Setting.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

enum Setting: Int, CaseIterable {
  case authInformation
  case serviceAlert
  case appVersion
  
  var title: String {
    switch self {
    case .authInformation:
      return "로그인 정보"
    case .serviceAlert:
      return "서비스 이용 알림"
    case .appVersion:
      return "앱 버전"
    }
  }
  
  var subTitle: String? {
    switch self {
    case .serviceAlert:
      return "서비스 사용(챌린지 현 등)과 관련된 알림을 보내드립니다."
    default:
      return nil
    }
  }
  
  var buttonType: SettingButtonType {
    switch self {
    case .authInformation:
      return .general
    case .serviceAlert:
      return .toggle
    case .appVersion:
      return .text
    }
  }
}

enum SettingButtonType {
  case general
  case toggle
  case text
}
