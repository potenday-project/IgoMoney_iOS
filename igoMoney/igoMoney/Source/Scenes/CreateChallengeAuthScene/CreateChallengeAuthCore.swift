//
//  CreateChallengeAuthCore.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import ComposableArchitecture

struct CreateChallengeAuthCore: Reducer {
  struct State: Equatable {
    let challenge: Challenge
    var money: String = ""
    
    init(challenge: Challenge) {
      self.challenge = challenge
    }
  }
  
  enum Action: Equatable {
    case moneyChanged(String)
  }
  
  func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case let .moneyChanged(changedString):
      state.money = changedString.map { String($0) }.compactMap { Int($0) }
        .map { String($0) }.joined()
      return .none
    }
  }
}
