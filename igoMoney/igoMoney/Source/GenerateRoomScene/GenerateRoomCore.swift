//
//  GenerateRoomCore.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

import ComposableArchitecture

struct GenerateRoomCore: Reducer {
  struct State: Equatable {
    var targetAmount: TargetMoneyAmount = .init(money: 10000)
    var selectionCategory: ChallengeCategory = .living
    var startDate: Date? = nil
    
    var title: String = ""
    var content: String = ""
    
    var endDate: Date {
      return calculateEndDate() ?? Date()
    }
    
    var isFillTitle: Bool {
      return (5...15) ~= title.count
    }
    
    var isFillContent: Bool {
      return content.count <= 50 && content.count != .zero
    }
  }
  
  enum Action: Equatable {
    case selectTargetAmount(TargetMoneyAmount)
    case selectCategory(ChallengeCategory)
    case selectDate(Date)
    case didChangeTitle(String)
    case didChangeContent(String)
  }
  
  func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case .selectTargetAmount(let amount):
      state.targetAmount = amount
      return .none
      
    case .selectCategory(let category):
      state.selectionCategory = category
      return .none
      
    case .selectDate(let selectedDate):
      state.startDate = selectedDate
      
      

      
      return .none
      
    case .didChangeTitle(let title):
      if title.count > 15 { return .none }
      state.title = title
      return .none
      
    case .didChangeContent(let content):
      if content.count > 50 { return .none }
      state.content = content
      return .none
      
    default:
      return .none
    }
  }
}

extension GenerateRoomCore.State {
  func calculateEndDate() -> Date? {
    var calendar = Calendar.current
    calendar.locale = Locale(identifier: "ko-KR")
    guard let startDate = startDate else { return nil }
    return calendar.date(byAdding: .day, value: 7, to: startDate) ?? startDate
  }
}
