//
//  ParticipatingChallengeResultSectionCore.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import ComposableArchitecture

struct ParticipatingChallengeResultSectionCore: Reducer {
  struct State: Equatable {
    let challengeID: Int
    
    var myChallengeCost: ChallengeCostResponse?
    var competitorChallengeCost: ChallengeCostResponse?
  }
  
  enum Action: Equatable {
    case onAppear
    
    case _fetchChallengeCost
    case _fetchChallengeCostResponse(TaskResult<[ChallengeCostResponse]>)
  }
  
  @Dependency(\.challengeClient) var challengeClient
  
  func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case .onAppear:
      return .send(._fetchChallengeCost)
      
    case ._fetchChallengeCost:
      return .run { [id = state.challengeID] send in
        await send(
          ._fetchChallengeCostResponse(
            TaskResult {
              try await challengeClient.challengeCosts(id.description)
            }
          )
        )
      }
      
    case ._fetchChallengeCostResponse(.success(let challengeCosts)):
      challengeCosts.forEach {
        if $0.fetchUserID == $0.userID {
          state.myChallengeCost = $0
        } else {
          state.competitorChallengeCost = $0
        }
      }
      
      return .none
      
    case ._fetchChallengeCostResponse(.failure):
      return .none
    }
  }
}
