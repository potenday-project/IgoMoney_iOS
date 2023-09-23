//
//  MyChallengeSectionCore.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

import ComposableArchitecture

struct ChallengeSituationCore: Reducer {
  struct State: Equatable {
    
  }
  
  enum Action {
    
  }
  
  func reduce(into state: inout State, action: Action) -> Effect<Action> {
    return .none
  }
}

struct MyChallengeSectionCore: Reducer {
  struct State: Equatable {
    var challengeState: ChallengeState = .challenging
    var presentSituation: Bool = false
    var challengeSituationState: ChallengeSituationCore.State? = nil
    
    enum ChallengeState: CaseIterable {
      case empty
      case waiting
      case challenging
      case result
    }
  }
  
  enum Action {
    case tapChallengeStatus
    
    case _presentChallengeSituation(Bool)
    
    case situationAction(ChallengeSituationCore.Action)
  }
  
  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .tapChallengeStatus:
        if state.challengeState == .challenging {
          return .run { send in
            await send(._presentChallengeSituation(true))
          }
        } else {
          return .none
        }
        
      case ._presentChallengeSituation(true):
        state.presentSituation = true
        state.challengeSituationState = ChallengeSituationCore.State()
        return .none
        
      case ._presentChallengeSituation(false):
        state.presentSituation = false
        state.challengeSituationState = nil
        return .none
      }
    }
    .ifLet(\.challengeSituationState, action: /Action.situationAction) {
      ChallengeSituationCore()
    }
  }
}
