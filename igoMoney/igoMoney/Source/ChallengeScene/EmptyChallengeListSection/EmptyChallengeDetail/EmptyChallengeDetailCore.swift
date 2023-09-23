//
//  EmptyChallengeDetailCore.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

import ComposableArchitecture

struct ChallengeDetailCore: Reducer {
  struct State: Equatable, Identifiable {
    let id: UUID
    
    var title: String
    var content: String
    var targetAmount: TargetMoneyAmount
    var user: User
  }
  
  enum Action: Equatable, Sendable {
    // User Action
    case didTap
  }
  
  func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case .didTap:
      return .none
    }
  }
}

