//
//  EnterChallengeCore.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import ComposableArchitecture
import Foundation

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
      print(#fileID, #function, #line, "Fetch Can Enter Response \(error)")
      if case let .badRequest(statusCode) = error as? APIError {
        state.canEnter = (statusCode == 409)
        return .none
      }
      
      state.canEnter = false
      return .none
    }
  }
}

struct EnterChallengeInformationCore: Reducer {
  struct State: Equatable {
    let challenge: Challenge
    
    var leaderName: String?
  }
  
  @Dependency(\.userClient) var userClient
  
  enum Action: Equatable {
    case onAppear
    case _fetchChallengeLeaderResponse(TaskResult<User>)
  }
  
  func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case .onAppear:
      return .run { [leaderID = state.challenge.leaderID] send in
        await send(
          ._fetchChallengeLeaderResponse(
            TaskResult {
              try await userClient.getUserInformation(leaderID.description)
            }
          )
        )
      }
      
    case ._fetchChallengeLeaderResponse(.success(let user)):
      state.leaderName = user.nickName
      return .none
      
    case ._fetchChallengeLeaderResponse(.failure):
      return .none
    }
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
    case showAlert(Bool)
    case enterChallenge
    
    case _requestEnterChallenge(TaskResult<Bool>)
    
    case enterChallengeInformationAction(EnterChallengeInformationCore.Action)
    case enterChallengeButtonAction(EnterChallengeButtonCore.Action)
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
    
    Reduce { state, action in
      switch action {
      case .showAlert(true):
        state.showAlert = true
        return .none
        
      case .showAlert(false):
        state.showAlert = false
        return .none
        
      case .enterChallenge:
        state.showAlert = false
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
        
      case .enterChallengeButtonAction(.didTapButton):
        return .send(.showAlert(true))
        
      case ._requestEnterChallenge(.success):
        state.showProgressView = false
        return .none
        
      case ._requestEnterChallenge(.failure):
        print("에러 발생")
        return .none
        
      default:
        return .none
      }
    }
  }
}
