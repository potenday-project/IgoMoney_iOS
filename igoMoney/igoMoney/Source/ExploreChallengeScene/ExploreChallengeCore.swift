//
//  ExploreChallengeCore.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

import ComposableArchitecture

struct ExploreChallengeCore: Reducer {
  struct State: Equatable {
    var challenges: IdentifiedArrayOf<ChallengeDetailCore.State> = []
    var selectedMoney: MoneyType = .all
    var showEnter: Bool = false
    var selectedChallenge: EnterChallengeCore.State?
  }
  
  enum Action: Equatable {
    // User Action
    case selectMoney(MoneyType)
    
    // Inner Action
    case _onAppear
    case _setShowEnter(Bool)
    
    // Child Action
    case detailAction(id: ChallengeDetailCore.State.ID, action: ChallengeDetailCore.Action)
    case enterAction(EnterChallengeCore.Action)
  }
  
  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
        // User Action
      case .selectMoney(let moneyType):
        state.selectedMoney = moneyType
        return .none
        
        // Inner Action
      case ._onAppear:
        let defaultValues = ChallengeInformation.default
        defaultValues.forEach {
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
        
      case ._setShowEnter(true):
        state.showEnter = true
        return .none
        
      case ._setShowEnter(false):
        state.showEnter = false
        state.selectedChallenge = nil
        return .none
        
        // Child Action
      case .detailAction(let id, action: .didTap):
        if let selectedItem = state.challenges.filter({ $0.id == id }).first {
          state.selectedChallenge = EnterChallengeCore.State(challengeDetailState: selectedItem)
        }
        
        return .run { send in
          await send(._setShowEnter(true))
        }
        
      case .detailAction:
        return .none
      }
    }
    .forEach(\.challenges, action: /Action.detailAction) {
      ChallengeDetailCore()
    }
    .ifLet(\.selectedChallenge, action: /Action.enterAction) {
      EnterChallengeCore()
    }
  }
}
