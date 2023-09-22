//
//  MainTab.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

enum MainTab: CaseIterable {
  case challenge
  case myPage
  
  var selectedIconName: String {
    switch self {
    case .challenge:
      return "icon_bolt_selected"
    case .myPage:
      return "icon_person_selected"
    }
  }
  
  var unSelectedIconName: String {
    switch self {
    case .challenge:
      return "icon_bolt_unselected"
    case .myPage:
      return "icon_person_unselected"
    }
  }
  
  var title: String {
    switch self {
    case .challenge:
      return "챌린지"
    case .myPage:
      return "마이페이지"
    }
  }
}
