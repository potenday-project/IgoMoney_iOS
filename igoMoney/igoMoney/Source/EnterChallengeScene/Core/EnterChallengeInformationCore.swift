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
