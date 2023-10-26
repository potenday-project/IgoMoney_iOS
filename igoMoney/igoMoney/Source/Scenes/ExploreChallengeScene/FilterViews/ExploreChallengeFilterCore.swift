//
//  ExploreChallengeFilterCore.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import ComposableArchitecture

struct ExploreChallengeFilterCore: Reducer {
  struct State: Equatable {
    var selectedCategory: ChallengeCategory?
    var selectedMoney: TargetMoneyAmount?
    var isSelectedAll: Bool = true
    
    var canConfirm: Bool {
      return selectedCategory != nil || selectedMoney != nil
    }
  }
  
  enum Action: Equatable {
    case selectCategory(ChallengeCategory?)
    case selectMoney(TargetMoneyAmount?)
    case selectAll(Bool)
    case confirm
  }
  
  func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case .selectCategory(.some(let category)):
      if state.selectedCategory == category {
        state.selectedCategory = nil
        return .none
      }
      
      state.selectedCategory = category
      return .send(.selectAll(false))
      
    case .selectCategory(.none):
      return .send(.selectAll(true))
      
    case .selectMoney(.some(let moneyAmount)):
      if state.selectedMoney == moneyAmount {
        state.selectedMoney = nil
        return .none
      }
      
      state.selectedMoney = moneyAmount
      return .send(.selectAll(false))
      
    case .selectMoney(.none):
      return .send(.selectAll(true))
      
    case .selectAll(true):
      state.selectedCategory = nil
      state.selectedMoney = nil
      state.isSelectedAll = true
      return .none
      
    case .selectAll(false):
      if state.isSelectedAll == true {
        if state.selectedCategory != nil || state.selectedMoney != nil {
          state.isSelectedAll = false
          return .none
        }
        
        return .none
      }
      return .none
      
    case .confirm:
      return .none
    }
  }
}
