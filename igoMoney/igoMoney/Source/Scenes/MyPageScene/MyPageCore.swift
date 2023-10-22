//
//  MyPageCore.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import ComposableArchitecture

enum CustomerServiceType: Int, CustomStringConvertible, CaseIterable {
  case share
  case review
  case inquiry
  case notice
  
  var description: String {
    switch self {
    case .share:
      return "앱 공유하기"
    case .review:
      return "앱 스토어 리뷰 남기기"
    case .inquiry:
      return "아이고머니에 문의하기"
    case .notice:
      return "공지사항 보기"
    }
  }
  
  var iconName: String {
    switch self {
    case .share:
      return "icon_share"
    case .review:
      return "icon_pancil"
    case .inquiry:
      return "icon_mail"
    case .notice:
      return "icon_volume"
    }
  }
}

struct MyPageCore: Reducer {
  struct State: Equatable {
    let customServices: [CustomerServiceType] = CustomerServiceType.allCases
    var settingState = SettingCore.State()
    var profileState = UserProfileCore.State()
  }
  
  enum Action {
    case settingAction(SettingCore.Action)
    case userProfileAction(UserProfileCore.Action)
  }
  
  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .userProfileAction:
        return .none
        
      default:
        return .none
      }
    }
    
    Scope(state: \.settingState, action: /Action.settingAction) {
      SettingCore()
    }
    
    Scope(state: \.profileState, action: /Action.userProfileAction) {
      UserProfileCore()
    }
  }
}
