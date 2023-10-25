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
    
    var imageState = URLImageCore.State()
    
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
    
    case urlImageAction(URLImageCore.Action)
  }
  
  @Dependency(\.userClient) var userClient
  
  var body: some Reducer<State, Action> {
    Scope(state: \.imageState, action: /Action.urlImageAction) {
      URLImageCore()
    }
    
    Reduce { state, action in
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
        return .send(.urlImageAction(._setURLPath(user.profileImagePath)))
        
      case ._challengeUserFetchResponse(.failure):
        return .none
        
      case .urlImageAction:
        return .none
      }
    }
  }
}
