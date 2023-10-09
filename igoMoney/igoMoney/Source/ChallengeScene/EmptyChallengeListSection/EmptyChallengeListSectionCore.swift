//
//  EmptyChallengeListSectionCore.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

import ComposableArchitecture

struct EmptyChallengeListSectionCore: Reducer {
  struct State: Equatable {
    var challenges: [Challenge] = []
    
    var showExplore: Bool = false
    
    var exploreChallengeState: ExploreChallengeCore.State?
    var enterChallengeSelection: Identified<ChallengeDetailCore.State.ID, EnterChallengeCore.State?>?
  }
  
  enum Action: Equatable, Sendable {
    // User Action
    case showExplore(Bool)
    case setEnterNavigation(selection: UUID?)
    
    // Inner Action
    case _onAppear
    case _setExploreState
    case _removeExploreState
    
    case _setNavigationEnterSelection
    
    case _notStartedChallengeListResponse(TaskResult<[Challenge]>)
    
    // Child Action
    case enterAction(EnterChallengeCore.Action)
    case exploreChallengeAction(ExploreChallengeCore.Action)
  }
  
  @Dependency(\.challengeClient) var challengeClient
  private enum CancelID { case load }
  
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
        
      case let .setEnterNavigation(.some(id)):
        state.enterChallengeSelection = Identified(nil, id: id)
        return .run { send in
          await send(._setNavigationEnterSelection)
        }
        .cancellable(id: CancelID.load, cancelInFlight: true)
        
      case .setEnterNavigation(.none):
        state.enterChallengeSelection = nil
        return .cancel(id: CancelID.load)
        
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
        
      case ._setNavigationEnterSelection:
        return .none
        
      case ._notStartedChallengeListResponse(.success(let challenges)):
        state.challenges = challenges
        return .none
        
      case ._notStartedChallengeListResponse(.failure):
        print("Error in fetch Empty Challenges")
        return .none
        
      case .exploreChallengeAction(.enterAction(._closeAlert)), .exploreChallengeAction(.dismiss):
        return .run { send in
          await send(.showExplore(false))
        }
        
      case .exploreChallengeAction:
        return .none
        
      case .enterAction(.dismiss):
        return .send(.setEnterNavigation(selection: nil), animation: .smooth)
        
      case .enterAction:
        return .none
      }
    }
    .ifLet(\.exploreChallengeState, action: /Action.exploreChallengeAction) {
      ExploreChallengeCore()
    }
   }
}
