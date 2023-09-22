//
//  ExploreChallengeCore.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

import ComposableArchitecture

struct ExploreChallengeCore: Reducer {
  struct State: Equatable {
    var challenges: IdentifiedArrayOf<ChallengeInformation> = IdentifiedArray(uniqueElements: ChallengeInformation.default)
    var selectedMoney: MoneyType = .all
    var selection: Identified<ChallengeInformation.ID, EnterChallengeCore.State?>?
    var isActivityIndicatorVisible: Bool = false
  }
  
  enum Action: Equatable {
    // User Action
    case selectMoney(MoneyType)
    
    // Inner Action
//    case _onAppear
    case _setNavigation(selection: UUID?)
    case _setNavigationSelection
    
    // Child Action
    case enterAction(EnterChallengeCore.Action)
  }
  
  private enum CancelID {
    case load
  }
  
  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
        // User Action
      case .selectMoney(let moneyType):
        state.selectedMoney = moneyType
        return .none
        
      // Inner Action
      case let ._setNavigation(selection: .some(id)):
        state.selection = Identified(nil, id: id)
        return .run { send in
          await send(._setNavigationSelection)
        }.cancellable(id: CancelID.load, cancelInFlight: true)
        
      case ._setNavigation(selection: .none):
        state.selection = nil
        return .cancel(id: CancelID.load)
        
      case ._setNavigationSelection:
        guard let id = state.selection?.id,
              let enterChallenge = state.challenges[id: id] else {
          return .none
        }
        
        state.selection?.value = EnterChallengeCore.State(challenge: enterChallenge)
        return .none
        
        // Child Action
      case .enterAction:
        return .none
      }
    }
    .ifLet(\.selection, action: /Action.enterAction) {
      EmptyReducer()
        .ifLet(\Identified<ChallengeInformation.ID, EnterChallengeCore.State?>.value, action: .self) {
          EnterChallengeCore()
        }
    }
  }
}
