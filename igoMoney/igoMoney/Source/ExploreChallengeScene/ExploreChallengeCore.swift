//
//  ExploreChallengeCore.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

import ComposableArchitecture

struct ExploreChallengeCore: Reducer {
  struct State: Equatable {
    var categorySelection: ChallengeCategory?
    var moneySelection: TargetMoneyAmount?
    
    var showFilter: Bool = false
    
    var isSelectAll: Bool {
      return (categorySelection == nil) && (moneySelection == nil)
    }
  }
  
  enum Action: Equatable {
    case openFilter(Bool)
    case removeFilter
    case confirmFilter
    
    case _setCategorySelection(ChallengeCategory?)
    case _setMoneySelection(TargetMoneyAmount?)
  }
  
  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .openFilter(true):
        state.showFilter = true
        return .concatenate(
          .send(._setCategorySelection(.living)),
          .send(._setMoneySelection(.init(money: 10000)))
        )
        
      case .openFilter(false):
        state.showFilter = false
        return .send(.removeFilter)
        
      case .removeFilter:
        return .concatenate(
          .send(._setMoneySelection(nil)),
          .send(._setCategorySelection(nil))
        )
        
      case .confirmFilter:
        state.showFilter = false
        return .none
        
      case ._setCategorySelection(let category):
        state.categorySelection = category
        return .none
        
      case ._setMoneySelection(let money):
        state.moneySelection = money
        return .none
        
      default:
        return .none
      }
    }
  }
}
