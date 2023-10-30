//
//  ParticipatingChallengeResultSectionCore.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import ComposableArchitecture

struct ParticipatingChallengeResultSectionCore: Reducer {
  struct State: Equatable {
    let challenge: Challenge
    
    var myChallengeCost: ChallengeResultCore.State?
    var competitorChallengeCost: ChallengeResultCore.State?
  }
  
  enum Action: Equatable {
    case onAppear
    
    case _fetchChallengeCost
    case _fetchChallengeCostResponse(TaskResult<[ChallengeCostResponse]>)
    
    case myChallengeCostAction(ChallengeResultCore.Action)
    case competitorChallengeCostAction(ChallengeResultCore.Action)
  }
  
  @Dependency(\.challengeClient) var challengeClient
  
  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .onAppear:
        return .send(._fetchChallengeCost)
        
      case ._fetchChallengeCost:
        return .run { [challenge = state.challenge] send in
          await send(
            ._fetchChallengeCostResponse(
              TaskResult {
                try await challengeClient.challengeCosts(challenge)
              }
            )
          )
        }
        
      case ._fetchChallengeCostResponse(.success(let challengeCosts)):
        challengeCosts.forEach {
          if $0.fetchUserID == $0.userID {
            state.myChallengeCost = ChallengeResultCore.State(cost: $0)
          } else {
            state.competitorChallengeCost = ChallengeResultCore.State(cost: $0)
          }
        }
        
        return .none
        
      case ._fetchChallengeCostResponse(.failure):
        return .none
        
      default:
        return .none
      }
    }
    .ifLet(\.myChallengeCost, action: /Action.myChallengeCostAction) {
      ChallengeResultCore()
    }
    .ifLet(\.competitorChallengeCost, action: /Action.competitorChallengeCostAction) {
      ChallengeResultCore()
    }
  }
}
