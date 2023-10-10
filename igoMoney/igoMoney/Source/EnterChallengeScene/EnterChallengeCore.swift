//
//  EnterChallengeCore.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import ComposableArchitecture

struct EnterChallengeButtonCore: Reducer {
  struct State: Equatable {
    var canEnter: Bool = true
    
    var buttonDisable: Bool {
      return canEnter == false
    }
  }
  
  @Dependency(\.challengeClient) var challengeClient
  
  enum Action: Equatable {
    case onAppear
    case _fetchEnterChallengeResponse(TaskResult<Challenge>)
  }
  
  func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case .onAppear:
      return .run { send in
        await send(
          ._fetchEnterChallengeResponse(
            TaskResult {
              try await challengeClient.getMyChallenge()
            }
          )
        )
      }
      
    case ._fetchEnterChallengeResponse(.success):
      state.canEnter = true
      return .none
      
    case ._fetchEnterChallengeResponse(.failure):
      state.canEnter = false
      return .none
    }
  }
}

struct EnterChallengeInformationCore: Reducer {
  struct State: Equatable {
    let challenge: Challenge
  }
  
  enum Action: Equatable {
    
  }
  
  func reduce(into state: inout State, action: Action) -> Effect<Action> {
    return .none
  }
}

struct EnterChallengeCore: Reducer {
  struct State: Equatable {
    var showAlert: Bool = false
    var showProgressView: Bool = false
    
    var enterChallengeButtonState = EnterChallengeButtonCore.State()
    var challengeInformationState: EnterChallengeInformationCore.State
    
    init(challenge: Challenge) {
      self.challengeInformationState = EnterChallengeInformationCore.State(challenge: challenge)
    }
  }
  
  enum Action: Equatable {
    case enterChallengeInformationAction(EnterChallengeInformationCore.Action)
    case enterChallengeButtonAction(EnterChallengeButtonCore.Action)
  }
  
  @Dependency(\.userClient) var userClient
  @Dependency(\.challengeClient) var challengeClient
  
  var body: some Reducer<State, Action> {
    Scope(state: \.challengeInformationState, action: /Action.enterChallengeInformationAction) {
      EnterChallengeInformationCore()
    }
    
    Scope(state: \.enterChallengeButtonState, action: /Action.enterChallengeButtonAction) {
      EnterChallengeButtonCore()
    }
    
    Reduce { state, action in
      return .none
    }
  }
}
