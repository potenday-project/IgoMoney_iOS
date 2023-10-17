//
//  EnterChallengeButtonCore.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

import ComposableArchitecture

struct EnterChallengeButtonCore: Reducer {
  struct State: Equatable {
    var canEnter: Bool = true
  }
  
  @Dependency(\.challengeClient) var challengeClient
  
  enum Action: Equatable {
    case onAppear
    case didTapButton
    
    case _fetchCanEnterResponse(TaskResult<Challenge>)
  }
  
  func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case .onAppear:
      return .run { send in
        await send(
          ._fetchCanEnterResponse(
            TaskResult {
              try await challengeClient.getMyChallenge()
            }
          )
        )
      }
      
    case .didTapButton:
      return .none
      
    case ._fetchCanEnterResponse(.success):
      state.canEnter = false
      return .none
      
    case ._fetchCanEnterResponse(.failure(let error)):
      if case let .badRequest(statusCode) = error as? APIError {
        state.canEnter = (statusCode == 409)
        return .none
      }
      
      state.canEnter = false
      return .none
    }
  }
}
