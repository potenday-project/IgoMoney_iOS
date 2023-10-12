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
    var titleState = TextFieldCore.State(textLimit: 15)
    var contentState = TextFieldCore.State(textLimit: 50)
  }
  
  enum Action: Equatable {
    case selectTargetAmount(TargetMoneyAmount)
    case selectCategory(ChallengeCategory)
    
    case titleAction(TextFieldCore.Action)
    case contentAction(TextFieldCore.Action)
  }
  
  var body: some Reducer<State, Action> {
    Scope(state: \.titleState, action: /Action.titleAction) {
      TextFieldCore()
    }
    
    Scope(state: \.contentState, action: /Action.contentAction) {
      TextFieldCore()
    }
    
    Reduce { state, action in
      switch action {
      case .selectTargetAmount(let amount):
        state.targetAmount = amount
        return .none
        
      case .selectCategory(let category):
        state.selectionCategory = category
        return .none
        
      default:
        return .none
      }
    }
  }
}
