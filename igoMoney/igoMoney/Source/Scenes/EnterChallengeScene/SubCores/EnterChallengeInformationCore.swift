//
//  EnterChallengeInformationCore.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

import ComposableArchitecture

struct EnterChallengeInformationCore: Reducer {
  struct State: Equatable {
    let challenge: Challenge
    
    var leaderName: String?
    
    var urlImageState = URLImageCore.State()
  }
  
  @Dependency(\.userClient) var userClient
  
  enum Action: Equatable {
    case onAppear
    
    case _fetchChallengeLeaderResponse(TaskResult<User>)
    
    case urlImageAction(URLImageCore.Action)
  }
  
  var body: some Reducer<State, Action> {
    Scope(state: \.urlImageState, action: /Action.urlImageAction) {
      URLImageCore()
    }
    
    Reduce { state, action in
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
        return .send(.urlImageAction(._setURLPath(user.profileImagePath)))
        
      case ._fetchChallengeLeaderResponse(.failure):
        return .none
        
      case .urlImageAction:
        return .none
      }
    }
  }
}
