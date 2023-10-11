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
  }
  
  enum Action: Equatable {
    case selectTargetAmount(TargetMoneyAmount)
    case selectCategory(ChallengeCategory)
    case didChangeTitle(String)
  }
  
  func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case .selectTargetAmount(let amount):
      state.targetAmount = amount
      return .none
      
    case .selectCategory(let category):
      state.selectionCategory = category
      return .none
      
    case .didChangeTitle(let title):
      state.title = title
      return .none
      
    default:
      return .none
    }
  }
}
