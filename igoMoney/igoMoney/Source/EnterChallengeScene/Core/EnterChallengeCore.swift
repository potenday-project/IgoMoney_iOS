//
//  EnterChallengeCore.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

import ComposableArchitecture

struct EnterChallengeCore: Reducer {
  struct State: Equatable {
    var showProgressView: Bool = false
    var dismissView: Bool = false
    
    var alertTitle: String = ""
    
    var enterChallengeButtonState = EnterChallengeButtonCore.State()
    var challengeInformationState: EnterChallengeInformationCore.State
    var alertState = IGOAlertCore.State()
    
    init(challenge: Challenge) {
      self.challengeInformationState = EnterChallengeInformationCore.State(challenge: challenge)
    }
  }
  
  enum Action: Equatable {
    case enterChallenge
    case dismissView
    
    case _requestEnterChallenge(TaskResult<Bool>)
    
    case enterChallengeInformationAction(EnterChallengeInformationCore.Action)
    case enterChallengeButtonAction(EnterChallengeButtonCore.Action)
    case alertAction(IGOAlertCore.Action)
  }
  
  @Dependency(\.userClient) var userClient
  @Dependency(\.challengeClient) var challengeClient
  
  var body: some Reducer<State, Action> {
    Scope(state: \.challengeInformationState, action: /Action.enterChallengeInformationAction) {
      #if DEBUG
      EnterChallengeInformationCore()
        ._printChanges()
      #else
      EnterChallengeInformationCore()
      #endif
    }
    
    Scope(state: \.enterChallengeButtonState, action: /Action.enterChallengeButtonAction) {
      #if DEBUG
      EnterChallengeButtonCore()
        ._printChanges()
      #else
      EnterChallengeButtonCore()
      #endif
    }
    
    Scope(state: \.alertState, action: /Action.alertAction) {
      IGOAlertCore()
    }
    
    Reduce { state, action in
      switch action {
      case .enterChallenge:
        state.showProgressView = true
        return .run { [challengeID = state.challengeInformationState.challenge.id] send in
          await send(
            ._requestEnterChallenge(
              TaskResult {
                try await challengeClient.enterChallenge(challengeID.description)
              }
            )
          )
        }
        
      case .dismissView:
        state.dismissView = true
        return .none
        
      case .enterChallengeButtonAction(.didTapButton):
        return .send(.alertAction(.present))
        
      case ._requestEnterChallenge(.success):
        state.showProgressView = false
        return .send(.dismissView)
        
      case ._requestEnterChallenge(.failure):
        print("에러 발생")
        return .none
        
      default:
        return .none
      }
    }
  }
}
