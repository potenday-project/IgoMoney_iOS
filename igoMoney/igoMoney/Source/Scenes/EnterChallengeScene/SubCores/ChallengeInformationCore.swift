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
    var competitorUser: User?
    var urlImageState = URLImageCore.State()
    
    var challengeDescription: String = ""
    
    var id: Int {
      return challenge.id
    }
  }
  
  @Dependency(\.userClient) var userClient
  
  enum Action: Equatable {
    case onAppear
    case fetchChallengeLeader(userID: Int)
    case fetchChallengeCompetitor(userID: Int?)
    
    case _fetchChallengeLeaderResponse(TaskResult<User>)
    case _fetchChallengeCompetitorResponse(TaskResult<User>)
    
    case urlImageAction(URLImageCore.Action)
  }
  
  var body: some Reducer<State, Action> {
    Scope(state: \.urlImageState, action: /Action.urlImageAction) {
      URLImageCore()
    }
    
    Reduce { state, action in
      switch action {
      case .onAppear:
        let competitorID = state.challenge.competitorID
        let leaderID = state.challenge.leaderID
        
        return .concatenate(
          .send(.fetchChallengeCompetitor(userID: competitorID)),
          .send(.fetchChallengeLeader(userID: leaderID))
        )
        
      case .fetchChallengeLeader(let userID):
        return .run { send in
          await send(
            ._fetchChallengeLeaderResponse(
              TaskResult {
                try await userClient.getUserInformation(userID.description)
              }
            )
          )
        }
        
      case .fetchChallengeCompetitor(let userID):
        return .run { send in
          await send(
            ._fetchChallengeCompetitorResponse(
              TaskResult {
                try await userClient.getUserInformation(userID?.description)
              }
            )
          )
        }
        
      case ._fetchChallengeLeaderResponse(.success(let user)):
        state.leader = user
        return .send(.urlImageAction(._setURLPath(user.profileImagePath)))
        
      case ._fetchChallengeLeaderResponse(.failure):
        return .none
        
      case ._fetchChallengeCompetitorResponse(.success(let user)):
        state.competitorUser = user
        
        let suffixDescription: String = state.challenge.isStart ? "님과 챌린지 진행 중" : "님 챌린지"
        state.challengeDescription = (user.nickName ?? "") + suffixDescription
        
        return .none
        
      case ._fetchChallengeCompetitorResponse(.failure):
        return .none
        
      case .urlImageAction:
        return .none
      }
    }
  }
}
