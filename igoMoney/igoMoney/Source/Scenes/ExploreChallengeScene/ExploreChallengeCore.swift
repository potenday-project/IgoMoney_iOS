//
//  ExploreChallengeCore.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

import ComposableArchitecture

struct ExploreChallengeCore: Reducer {
  struct State: Equatable {
    var challenges: IdentifiedArrayOf<ChallengeInformationCore.State> = []
    var generateState = GenerateRoomCore.State()
    var filterState = ExploreChallengeFilterCore.State()
    var selectedChallenge: EnterChallengeCore.State?
    
    var selectedChallengeID: Int?
    var showGenerate: Bool = false
    var showFilter: Bool = false
  }
  
  enum Action: Equatable {
    case openFilter(Bool)
    
    case requestFetchChallenges
    
    case showGenerate(Bool)
    case selectChallenge(Int?)

    case _fetchUserInChallenge
    case _filterChallengeResponse(TaskResult<[Challenge]>)
    case _fetchUserInChallengeResponse(TaskResult<Challenge>)

    case challengeInformationAction(Int, ChallengeInformationCore.Action)
    case enterChallengeAction(EnterChallengeCore.Action)
    case filterChallengeAction(ExploreChallengeFilterCore.Action)
    case generateChallengeAction(GenerateRoomCore.Action)
  }
  
  @Dependency(\.challengeClient) var challengeClient
  
  var body: some Reducer<State, Action> {
    Scope(state: \.generateState, action: /Action.generateChallengeAction) {
      GenerateRoomCore()
    }
    
    Scope(state: \.filterState, action: /Action.filterChallengeAction) {
      ExploreChallengeFilterCore()
    }
    
    Reduce { state, action in
      switch action {
      case .openFilter(true):
        state.showFilter = true
        return .none
        
      case .openFilter(false):
        state.showFilter = false
        return .send(.filterChallengeAction(.selectAll(true)))
        
      case .showGenerate(true):
        return .send(._fetchUserInChallenge)
        
      case .showGenerate(false):
        state.showGenerate = false
        return .none
        
      case .selectChallenge(.some(let id)):
        guard let selectedItem = state.challenges[id: id]?.challenge else {
          return .none
        }
        
        state.selectedChallengeID = id
        state.selectedChallenge = EnterChallengeCore.State(challenge: selectedItem)
        return .none
        
      case .selectChallenge(.none):
        state.selectedChallenge = nil
        state.selectedChallengeID = nil
        return .none
        
      case ._fetchUserInChallenge:
        return .run { send in
          await send(
            ._fetchUserInChallengeResponse(
              TaskResult {
                try await challengeClient.getMyChallenge()
              }
            )
          )
        }
        
      case .requestFetchChallenges:
        return .run { send in
          await send(
            ._filterChallengeResponse(
              TaskResult {
                try await challengeClient.fetchNotStartedChallenge()
              }
            )
          )
        }
        
      case ._filterChallengeResponse(.success(let challenges)):
        let informations = challenges.map { ChallengeInformationCore.State(challenge: $0) }
        state.challenges = IdentifiedArray(uniqueElements: informations)
        return .none
        
      case ._filterChallengeResponse(.failure):
        state.challenges = []
        return .none
        
      case ._fetchUserInChallengeResponse(.success):
        return .send(.showGenerate(false))
        
      case ._fetchUserInChallengeResponse(.failure):
        state.showGenerate = true
        return .none
        
      case .filterChallengeAction(.selectCategory), .filterChallengeAction(.selectMoney):
        return .send(.openFilter(true))
        
      case .filterChallengeAction(.confirm):
        return .none
        
      default:
        return .none
      }
    }
    .ifLet(\.selectedChallenge, action: /Action.enterChallengeAction) {
      EnterChallengeCore()
    }
    .forEach(\.challenges, action: /Action.challengeInformationAction) {
      ChallengeInformationCore()
    }
  }
}
