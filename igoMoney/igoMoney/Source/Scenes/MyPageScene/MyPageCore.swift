//
//  MyPageCore.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import ComposableArchitecture
import Foundation

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
    static func == (lhs: MyPageCore.State, rhs: MyPageCore.State) -> Bool {
      return (lhs.profileState == rhs.profileState) &&
      (lhs.settingState == rhs.settingState) &&
      (lhs.shareItem?.count == rhs.shareItem?.count) &&
      (lhs.showMail == rhs.showMail)
    }
    
    let customServices: [CustomerServiceType] = CustomerServiceType.allCases
    var settingState = SettingCore.State()
    var profileState = UserProfileCore.State()
    var profileEditState = ProfileSettingCore.State()
    
    var presentProfileEdit: Bool = false
    var shareItem: [Any]?
    var showMail: Bool = false
  }
  
  enum Action {
    case tapService(CustomerServiceType)
    case tapProfileEdit
    
    case _presentShare([Any]?)
    case _presentMail(Bool)
    case _presentProfileEdit(Bool)
    
    case settingAction(SettingCore.Action)
    case userProfileAction(UserProfileCore.Action)
  }
  
  @Dependency(\.openURL) var openURL
  
  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .userProfileAction:
        return .none
        
      case .tapProfileEdit:
        return .send(._presentProfileEdit(true))
        
      case .tapService(let service):
        switch service {
        case .share:
          guard let appStoreURL = URL(string: "https://apps.apple.com/us/app/igomoney/id6467229873") else {
            return .send(._presentShare(nil))
          }
          return .send(._presentShare([appStoreURL]))
          
        case .inquiry:
          state.showMail = true
          return .none
          
        default:
          return .none
        }
        
      case ._presentShare(let item):
        state.shareItem = item
        return .none
        
      case let ._presentMail(isPresent):
        state.showMail = isPresent
        return .none
        
      case let ._presentProfileEdit(isPresent):
        state.presentProfileEdit = isPresent
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
