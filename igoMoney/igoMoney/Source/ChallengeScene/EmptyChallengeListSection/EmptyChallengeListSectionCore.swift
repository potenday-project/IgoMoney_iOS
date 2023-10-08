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
    case notStartedChallengeListResponse(TaskResult<[Challenge]>)
    
    // Child Action
    case challengeDetail(id: ChallengeDetailCore.State.ID, action: ChallengeDetailCore.Action)
    case exploreChallengeAction(ExploreChallengeCore.Action)
  }
  
  @Dependency(\.challengeClient) var challengeClient
  
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
        return .run { send in
          await send(
            .notStartedChallengeListResponse(
              TaskResult {
                try await challengeClient.fetchNotStartedChallenge()
              }
            )
          )
        }
        
      case ._setExploreState:
        state.exploreChallengeState = ExploreChallengeCore.State()
        state.showExplore = true
        return .none
        
      case ._removeExploreState:
        state.exploreChallengeState = nil
        state.showExplore = false
        return .none
        
      case .notStartedChallengeListResponse(.success(let challenges)):
        let challengeStates = challenges.map { ChallengeDetailCore.State(challenge: $0) }
        state.challenges = IdentifiedArray(uniqueElements: challengeStates)
        return .none
        
      case .notStartedChallengeListResponse(.failure):
        print("Error in fetch Empty Challenges")
        return .none
        // Child Action
      case .challengeDetail:
        return .none
        
      case .exploreChallengeAction(.enterAction(._closeAlert)), .exploreChallengeAction(.dismiss):
        return .run { send in
          await send(.showExplore(false))
        }
        
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
