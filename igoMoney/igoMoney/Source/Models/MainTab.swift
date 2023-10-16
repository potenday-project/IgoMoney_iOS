//
//  MainTab.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

enum MainTab: CaseIterable {
  case home
  case myPage
  
  var selectedIconName: String {
    switch self {
    case .home:
      return "icon_home_selected"
    case .myPage:
      return "icon_person_selected"
    }
  }
  
  var unSelectedIconName: String {
    switch self {
    case .home:
      return "icon_home_unselected"
    case .myPage:
      return "icon_person_unselected"
    }
  }
  
  var title: String {
    switch self {
    case .home:
      return "홈"
    case .myPage:
      return "마이페이지"
    }
  }
}
