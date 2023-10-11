//
//  ExploreChallengeCore.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

import ComposableArchitecture

struct ExploreChallengeCore: Reducer {
  struct State: Equatable {
    var challenges: IdentifiedArrayOf<Challenge> = []
    var selectedMoney: MoneyType = .all
    var selection: Identified<Challenge.ID, EnterChallengeCore.State?>?
    
    var showGenerate: Bool = false
    var isActivityIndicatorVisible: Bool = false
    
    var generateState = GenerateRoomCore.State()
  }
  
  enum Action: Equatable {
    // User Action
    case selectMoney(MoneyType)
    case showGenerate(Bool)
    case dismiss
    
    // Inner Action
    case _setNavigation(selection: Int?)
    case _setNavigationSelection
    
    // Child Action
    case enterAction(EnterChallengeCore.Action)
    case generateAction(GenerateRoomCore.Action)
  }
  
  private enum CancelID {
    case load
  }
  
  var body: some Reducer<State, Action> {
    Scope(state: \.generateState, action: /Action.generateAction) {
      GenerateRoomCore()
    }
    
    Reduce { state, action in
      switch action {
        // User Action
      case .selectMoney(let moneyType):
        state.selectedMoney = moneyType
        return .none
        
      case .showGenerate(true):
        state.showGenerate = true
        return .none
        
      case .showGenerate(false):
        state.showGenerate = false
        return .none
        
      case .dismiss:
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
//        guard let id = state.selection?.id,
//              let enterChallenge = state.challenges[id: id] else {
//          return .none
//        }
//        
//        state.selection?.value = EnterChallengeCore.State(challenge: enterChallenge)
//        return .none
        
        return .none
        
        // Child Action
      case .enterAction:
        return .none
      }
    }
    .ifLet(\.selection, action: /Action.enterAction) {
      EmptyReducer()
        .ifLet(\Identified<Challenge.ID, EnterChallengeCore.State?>.value, action: .self) {
          EnterChallengeCore()
        }
    }
  }
}
