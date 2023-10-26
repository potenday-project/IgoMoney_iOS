//
//  EnterChallengeInformationCore.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

import ComposableArchitecture

struct ChallengeInformationCore: Reducer {
  struct State: Equatable, Identifiable {
    let challenge: Challenge
    var leader: User?
    var urlImageState = URLImageCore.State()
    
    var id: Int {
      return challenge.id
    }
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
        state.leader = user
        return .send(.urlImageAction(._setURLPath(user.profileImagePath)))
        
      case ._fetchChallengeLeaderResponse(.failure):
        return .none
        
      case .urlImageAction:
        return .none
      }
    }
  }
}
