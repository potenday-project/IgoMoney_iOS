//
//  ExploreChallengeCore.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

import ComposableArchitecture

struct ExploreChallengeCore: Reducer {
  struct State: Equatable {
    var challenges: IdentifiedArrayOf<EnterChallengeInformationCore.State> = []
    
    var generateState = GenerateRoomCore.State()
    var challengeSelection: EnterChallengeCore.State?
    var categorySelection: ChallengeCategory?
    var moneySelection: TargetMoneyAmount?
    
    var showGenerate: Bool = false
    var showFilter: Bool = false
    
    var isSelectAll: Bool {
      return (categorySelection != nil) && (moneySelection != nil)
    }
  }
  
  enum Action: Equatable {
    case openFilter(Bool)
    case removeFilter
    case confirmFilter
    
    case requestFetchChallenges
    
    case showGenerate(Bool)
    case selectChallenge(Challenge?)
    case selectCategory(ChallengeCategory)
    case selectMoney(TargetMoneyAmount)

    case _filterChallengeResponse(TaskResult<[Challenge]>)
    case _setCategorySelection(ChallengeCategory?)
    case _setMoneySelection(TargetMoneyAmount?)

    case challengeInformationAction(Int, EnterChallengeInformationCore.Action)
    case enterChallengeAction(EnterChallengeCore.Action)
    case generateChallengeAction(GenerateRoomCore.Action)
  }
  
  @Dependency(\.challengeClient) var challengeClient
  
  var body: some Reducer<State, Action> {
    Scope(state: \.generateState, action: /Action.generateChallengeAction) {
      GenerateRoomCore()
    }
    
    Reduce { state, action in
      switch action {
      case .openFilter(true):
        state.showFilter = true
        return .concatenate(
          .send(._setCategorySelection(.living)),
          .send(._setMoneySelection(.init(money: 10000)))
        )
        
      case .openFilter(false):
        state.showFilter = false
        return .send(.removeFilter)
        
      case .removeFilter:
        return .concatenate(
          .send(._setMoneySelection(nil)),
          .send(._setCategorySelection(nil))
        )
        
      case .confirmFilter:
        state.showFilter = false
        return .none
        
      case .showGenerate(true):
        state.showGenerate = true
        return .none
        
      case .showGenerate(false):
        state.showGenerate = false
        return .none
        
      case .selectChallenge(.some(let challenge)):
        state.challengeSelection = EnterChallengeCore.State(challenge: challenge)
        return .none
        
      case .selectChallenge(.none):
        state.challengeSelection = nil
        return .none
        
      case .selectCategory(let category):
        return .send(._setCategorySelection(category))
        
      case .selectMoney(let money):
        return .send(._setMoneySelection(money))
        
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
        
      case ._setCategorySelection(let category):
        state.categorySelection = category
        return .none
        
      case ._setMoneySelection(let money):
        state.moneySelection = money
        return .none
        
      case ._filterChallengeResponse(.success(let challenges)):
        let informations = challenges.map { EnterChallengeInformationCore.State(challenge: $0) }
        state.challenges = IdentifiedArray(uniqueElements: informations)
        return .none
        
      case ._filterChallengeResponse(.failure):
        state.challenges = []
        return .none
        
      default:
        return .none
      }
    }
    .ifLet(\.challengeSelection, action: /Action.enterChallengeAction) {
      EnterChallengeCore()
    }
    .forEach(\.challenges, action: /Action.challengeInformationAction) {
      EnterChallengeInformationCore()
    }
  }
}
