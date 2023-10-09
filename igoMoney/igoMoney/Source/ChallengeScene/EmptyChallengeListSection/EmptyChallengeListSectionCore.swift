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
    
    var showEnter: Bool = false
    var showExplore: Bool = false
    
    var enterChallengeState: EnterChallengeCore.State?
    var exploreChallengeState: ExploreChallengeCore.State?
  }
  
  enum Action: Equatable, Sendable {
    // User Action
    case showExplore(Bool)
    case showEnter(Bool)
    
    // Inner Action
    case _onAppear
    case _setExploreState
    case _removeExploreState
    case _setEnterState(challenge: Challenge?)
    case _removeEnterState
    case _notStartedChallengeListResponse(TaskResult<[Challenge]>)
    
    // Child Action
    case challengeDetail(id: ChallengeDetailCore.State.ID, action: ChallengeDetailCore.Action)
    case exploreChallengeAction(ExploreChallengeCore.Action)
    case enterChallengeAction(EnterChallengeCore.Action)
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
        
      case .showEnter(true):
        return .none
        
      case .showEnter(false):
        return .none
        
        // Inner Action
      case ._onAppear:
        return .run { send in
          await send(
            ._notStartedChallengeListResponse(
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
        
      case ._setEnterState(let challenge):
        guard let challenge = challenge else { return .none }
        state.enterChallengeState = EnterChallengeCore.State(challenge: challenge)
        state.showEnter = true
        return .none
        
      case ._removeEnterState:
        state.enterChallengeState = nil
        state.showEnter = false
        return .none
        
      case ._notStartedChallengeListResponse(.success(let challenges)):
        let challengeStates = challenges.map { ChallengeDetailCore.State(challenge: $0) }
        state.challenges = IdentifiedArray(uniqueElements: challengeStates)
        return .none
        
      case ._notStartedChallengeListResponse(.failure):
        print("Error in fetch Empty Challenges")
        return .none
        // Child Action
        
      case .challengeDetail(let id, .didTap):
        let challenge = state.challenges.filter({ $0.id == id }).first?.challenge
        return .run { send in
          await send(._setEnterState(challenge: challenge))
        }
        
      case .challengeDetail:
        return .none
        
      case .exploreChallengeAction(.enterAction(._closeAlert)), .exploreChallengeAction(.dismiss):
        return .run { send in
          await send(.showExplore(false))
        }
        
      case .exploreChallengeAction:
        return .none
        
      case .enterChallengeAction:
        return .none
      }
    }
    .ifLet(\.exploreChallengeState, action: /Action.exploreChallengeAction) {
      ExploreChallengeCore()
    }
    .ifLet(\.enterChallengeState, action: /Action.enterChallengeAction) {
      EnterChallengeCore()
    }
    .forEach(\.challenges, action: /Action.challengeDetail) {
      ChallengeDetailCore()
    }
   }
}
