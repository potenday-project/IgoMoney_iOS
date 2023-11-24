//
//  DeclarationCore.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation
import ComposableArchitecture

struct DeclarationCore: Reducer {
  struct State: Equatable {
    let record: ChallengeRecord
    var selectedReason: Int?
    var alertState = IGOAlertCore.State()
    var dismissView = false
  }
  
  enum Action: Equatable {
    case dismissView
    case didTapDeclaration(reason: Int)
    case acceptDeclaration
    
    case _postDeclaration
    case _postDeclarationResponse(TaskResult<Data>)
    
    case alertAction(IGOAlertCore.Action)
  }
  
  @Dependency(\.recordClient) var recordClient
  
  var body: some Reducer<State, Action> {
    Scope(state: \.alertState, action: /Action.alertAction) {
      IGOAlertCore()
    }
    
    Reduce { state, action in
      switch action {
      case .dismissView:
        state.dismissView = true
        return .none
        
      case let .didTapDeclaration(reason):
        state.selectedReason = reason
        return .send(.alertAction(.present))
        
      case .acceptDeclaration:
        
        return .send(._postDeclaration)
        
      case ._postDeclaration:
        guard let reason = state.selectedReason else {
          return .send(.alertAction(.dismiss))
        }
        
        return .run { [state = state] send in
          await send(
            ._postDeclarationResponse(
              TaskResult {
                try await recordClient.reportRecord(state.record, reason)
              }
            )
          )
        }
        
      case ._postDeclarationResponse(.success):
        return .concatenate(
          .send(.dismissView),
          .send(.alertAction(.dismiss))
        )
        
      case ._postDeclarationResponse(.failure):
        return .send(.alertAction(.dismiss))
        
      case .alertAction:
        return .none
      }
    }
  }
}
