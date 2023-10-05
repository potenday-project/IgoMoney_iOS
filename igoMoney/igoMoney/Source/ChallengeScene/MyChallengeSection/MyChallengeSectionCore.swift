//
//  MyChallengeSectionCore.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

import ComposableArchitecture

struct ChallengeSituationCore: Reducer {
  struct State: Equatable {
    
  }
  
  enum Action {
    
  }
  
  func reduce(into state: inout State, action: Action) -> Effect<Action> {
    return .none
  }
}

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
                try await challengeClient.getMyChallenge("4")
              }
            )
          )
        }
        
      case ._myChallengeResponse(.success(let challenge)):
        state.currentChallengeState = challenge
        return .none
        
      case ._myChallengeResponse(.failure(let error)):
        print(error)
        return .none
        
      default:
        return .none
      }
    }
  }
}
