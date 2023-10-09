//
//  EmptyChallengeDetailCore.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

import ComposableArchitecture

struct ChallengeDetailCore: Reducer {
  struct State: Equatable, Identifiable {
    let id: UUID
    
    var title: String
    var content: String
    var targetAmount: TargetMoneyAmount
    var leader: User
    
    var challenge: Challenge
    
    init(challenge: Challenge) {
      self.id = UUID()
      self.title = challenge.title
      self.content = challenge.content
      self.targetAmount = challenge.targetAmount
      self.leader = User(userID: challenge.leaderID)
      self.challenge = challenge
    }
  }
  
  enum Action: Equatable, Sendable {
    // User Action
    // Inner Action
    case _onAppear
    case _challengeUserFetchResponse(TaskResult<User>)
  }
  
  @Dependency(\.userClient) var userClient
  
  func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case ._onAppear:
      return .run { [state] send in
        await send(
          ._challengeUserFetchResponse(
            TaskResult {
              try await userClient.getUserInformation(state.leader.userID.description)
            }
          )
        )
      }
      
    case ._challengeUserFetchResponse(.success(let user)):
      state.leader = user
      return .none
      
    case ._challengeUserFetchResponse(.failure):
      return .none
    }
  }
}
