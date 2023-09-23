//
//  MyChallengeSectionCore.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

import ComposableArchitecture

struct MyChallengeSectionCore: Reducer {
  struct State: Equatable {
    var challengeState: ChallengeState = .empty
    
    enum ChallengeState: CaseIterable {
      case empty
      case waiting
      case challenging
      case result
    }
  }
  
  enum Action: Equatable {
    case changeState
  }
  
  func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case .changeState:
      guard let randomState = State.ChallengeState.allCases.randomElement() else {
        return .none
      }
      state.challengeState = randomState
      return .none
    }
  }
}
