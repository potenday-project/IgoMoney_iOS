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
    var isLoading: Bool = false
  }
  
  enum Action: Equatable {
    case openFilter(Bool)
    case showGenerate(Bool)
    case selectChallenge(Int?)
    case onAppearList(ChallengeInformationCore.State)

    case _fetchUserInChallenge
    case _filterChallenges
    case _requestFetchChallenges
    case _requestMoreChallenges(lastID: Int)
    case _requestChallengeResponse(TaskResult<[Challenge]>)
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
        
      case ._requestFetchChallenges:
        state.isLoading = true
        return .run { [state = state.filterState] send in
          await send(
            ._requestChallengeResponse(
              TaskResult {
                try await challengeClient.fetchNotStartedChallenge(
                  nil,
                  state.selectedCategory?.rawValue,
                  state.selectedMoney?.money
                )
              }
            )
          )
        }
        
      case ._requestChallengeResponse(.success(let challenges)):
        state.isLoading = false
        
        let informations = challenges.map { ChallengeInformationCore.State(challenge: $0) }
        state.challenges += IdentifiedArray(uniqueElements: informations)

        state.challenges.sort(by: { $0.id < $1.id })
        return .none
        
      case ._requestChallengeResponse(.failure):
        state.isLoading = false
        state.challenges = []
        return .none
        
      case ._fetchUserInChallengeResponse(.success):
        return .send(.showGenerate(false))
        
      case ._fetchUserInChallengeResponse(.failure):
        state.showGenerate = true
        return .none
        
      case ._requestMoreChallenges(let lastID):
        state.isLoading = true
        return .run { [state = state.filterState] send in
          try await Task.sleep(nanoseconds: 1_000_000_000)
          await send(
            ._requestChallengeResponse(
              TaskResult {
                try await challengeClient.fetchNotStartedChallenge(
                  lastID,
                  state.selectedCategory?.rawValue,
                  state.selectedMoney?.money
                )
              }
            )
          )
        }
        
      case ._filterChallenges:
        let challenges = state.challenges
        let category = state.filterState.selectedCategory
        
        state.challenges = challenges.filter { $0.challenge.category == category }
        return .none
        
      case .filterChallengeAction(.selectCategory), .filterChallengeAction(.selectMoney):
        return .send(.openFilter(true))
        
      case .filterChallengeAction(.confirm):
        state.showFilter = false
        return .send(._filterChallenges)
        
      case .filterChallengeAction(.selectAll(true)):
        return .send(._requestFetchChallenges)
        
      case .onAppearList(let challengeState):
        if state.challenges.isEmpty || state.isLoading {
          return .none
        }
        
        if state.challenges.last == challengeState {
          let id = challengeState.challenge.id
          return .send(._requestMoreChallenges(lastID: id + 1))
        }
        
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
