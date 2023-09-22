//
//  EmptyChallengeListSectionCore.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

import ComposableArchitecture

struct EmptyChallengeListSectionCore: Reducer {
  struct State: Equatable {
    var challenges: IdentifiedArrayOf<ChallengeDetailCore.State> = []
    var showExplore: Bool = false
    var exploreChallengeState: ExploreChallengeCore.State?
  }
  
  enum Action: Equatable, Sendable {
    // User Action
    case showExplore(Bool)
    
    // Inner Action
    case _onAppear
    case _setExploreState
    case _removeExploreState
    
    // Child Action
    case challengeDetail(id: ChallengeDetailCore.State.ID, action: ChallengeDetailCore.Action)
    case exploreChallengeAction(ExploreChallengeCore.Action)
  }
  
  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
        // User Action
      case .showExplore(true):
        return .run { send in
          await send(._setExploreState)
        }
      case .showExplore(false):
        return .run { send in
          await send(._removeExploreState)
        }
        
        // Inner Action
      case ._onAppear:
        let informations = ChallengeInformation.default
        informations.forEach {
          let detailState = ChallengeDetailCore.State(
            id: UUID(),
            title: $0.title,
            content: $0.content,
            targetAmount: $0.targetAmount,
            user: $0.user
          )
          state.challenges.append(detailState)
        }
        
        return .none
        
      case ._setExploreState:
        state.exploreChallengeState = ExploreChallengeCore.State()
        state.showExplore = true
        return .none
        
      case ._removeExploreState:
        state.exploreChallengeState = nil
        state.showExplore = false
        return .none
        
        
        // Child Action
      case .challengeDetail:
        return .none
        
      case .exploreChallengeAction:
        return .none
      }
    }
    .ifLet(\.exploreChallengeState, action: /Action.exploreChallengeAction) {
      ExploreChallengeCore()
    }
    .forEach(\.challenges, action: /Action.challengeDetail) {
      ChallengeDetailCore()
    }
  }
}
