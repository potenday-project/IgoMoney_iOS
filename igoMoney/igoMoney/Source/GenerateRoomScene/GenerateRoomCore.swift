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
  }
  
  func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case .selectTargetAmount(let amount):
      state.targetAmount = amount
      return .none
      
    default:
      return .none
    }
  }
}
