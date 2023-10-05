//
//  MyChallengeSectionCore.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

import ComposableArchitecture

struct MyChallengeSectionCore: Reducer {
  struct State: Equatable {
    var currentChallengeState: Challenge?
  }
  
  enum Action {
    case _onAppear
    case _myChallengeResponse(TaskResult<Challenge>)
    
    // Child Action
  }
  
  @Dependency(\.challengeClient) var challengeClient
  
  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
        
      case ._onAppear:
        return .run { send in
          await send(
            ._myChallengeResponse(
              TaskResult {
                try await challengeClient.getMyChallenge()
              }
            )
          )
        }
        
      case ._myChallengeResponse(.success(let challenge)):
        state.currentChallengeState = challenge
        return .none
        
      case ._myChallengeResponse(.failure(let error as APIError)):
        if case APIError.badRequest(409) = error {
          state.currentChallengeState = nil
        }
        
        return .none
        
      default:
        return .none
      }
    }
  }
}
