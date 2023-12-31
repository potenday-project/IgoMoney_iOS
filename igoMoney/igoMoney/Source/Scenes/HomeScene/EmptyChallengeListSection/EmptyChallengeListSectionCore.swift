//
//  EmptyChallengeListSectionCore.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

import ComposableArchitecture

struct EmptyChallengeListSectionCore: Reducer {
  struct State: Equatable {
    var challenges: IdentifiedArrayOf<ChallengeInformationCore.State> = []
    
    var enterSelectionID: Int?
    var enterSelection: EnterChallengeCore.State?
    
    var showExplore: Bool = false
    var exploreChallengeState: ExploreChallengeCore.State?
    
    var showGenerate: Bool = false
    var generateChallengeState = GenerateRoomCore.State()
  }
  
  enum Action: Equatable, Sendable {
    // User Action
    case showExplore(Bool)
    case showEnter(Int?)
    case showGenerate(Bool)
    
    // Inner Action
    case _onAppear
    case _setExploreState
    case _removeExploreState
    
    case _notStartedChallengeListResponse(TaskResult<[Challenge]>)
    
    // Child Action
    case challengeInformationAction(Int, ChallengeInformationCore.Action)
    case exploreChallengeAction(ExploreChallengeCore.Action)
    case enterAction(EnterChallengeCore.Action)
    case generateAction(GenerateRoomCore.Action)
  }
  
  @Dependency(\.challengeClient) var challengeClient
  private enum CancelID { case load }
  
  var body: some Reducer<State, Action> {
    Scope(state: \.generateChallengeState, action: /Action.generateAction) {
      GenerateRoomCore()
    }
    
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
        
      case let .showEnter(.some(id)):
        guard let selectedChallenge = state.challenges[id: id]?.challenge else {
          return .none
        }
        
        state.enterSelectionID = id
        state.enterSelection = EnterChallengeCore.State(challenge: selectedChallenge)
        return .none
        
      case .showEnter(.none):
        state.enterSelection = nil
        state.enterSelectionID = nil
        return .none
        
      case .showGenerate(true):
        state.showGenerate = true
        return .none
        
      case .showGenerate(false):
        state.showGenerate = false
        return .none
        
      case ._onAppear:
        return .run { send in
          await send(
            ._notStartedChallengeListResponse(
              TaskResult {
                try await challengeClient.fetchNotStartedChallenge(nil, nil, nil)
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
        
      case ._notStartedChallengeListResponse(.success(let challenges)):
        let emptyChallenges = challenges.map { ChallengeInformationCore.State(challenge: $0) }
        state.challenges = IdentifiedArray(uniqueElements: emptyChallenges)
        return .none
        
      case ._notStartedChallengeListResponse(.failure):
        print("Error in fetch Empty Challenges")
        return .none
        
      case .exploreChallengeAction:
        return .none
        
      case .enterAction:
        return .none
        
      case .generateAction(.alertAction(.dismiss)):
        state.showGenerate = false
        return .none
        
      case .generateAction:
        return .none
        
      case .challengeInformationAction:
        return .none
      }
    }
    .ifLet(\.exploreChallengeState, action: /Action.exploreChallengeAction) {
      ExploreChallengeCore()
    }
    .ifLet(\.enterSelection, action: /Action.enterAction) {
      EnterChallengeCore()
    }
    .forEach(\.challenges, action: /Action.challengeInformationAction) {
      ChallengeInformationCore()
    }
   }
}
