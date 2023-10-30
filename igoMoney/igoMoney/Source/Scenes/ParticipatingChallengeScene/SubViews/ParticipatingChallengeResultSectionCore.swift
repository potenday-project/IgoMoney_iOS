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
    
    var winnerName: String = ""
  }
  
  enum Action: Equatable {
    case onAppear
    
    case _fetchChallengeCost
    case _fetchChallengeCostResponse(TaskResult<[ChallengeCostResponse]>)
    case _fetchWinnerInformation(id: Int)
    case _fetchWinnerInformationResponse(TaskResult<User>)
    
    case myChallengeCostAction(ChallengeResultCore.Action)
    case competitorChallengeCostAction(ChallengeResultCore.Action)
  }
  
  @Dependency(\.userClient) var userClient
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
            state.myChallengeCost = ChallengeResultCore.State(
              challenge: state.challenge,
              cost: $0
            )
          } else {
            state.competitorChallengeCost = ChallengeResultCore.State(
              challenge: state.challenge,
              cost: $0
            )
          }
        }
        
        var minCost = Int.max
        var minID: Int? = nil
        
        for cost in challengeCosts {
          if cost.totalCost < minCost {
            minCost = cost.totalCost
            minID = cost.userID
          }
        }
        
        guard let winnerID = minID else { return .none }
        
        return .send(._fetchWinnerInformation(id: winnerID))
        
      case ._fetchChallengeCostResponse(.failure):
        return .none
        
      case ._fetchWinnerInformation(let id):
        return .run { send in
          await send(
            ._fetchWinnerInformationResponse(
              TaskResult {
                try await userClient.getUserInformation(id.description)
              }
            )
          )
        }
        
      case ._fetchWinnerInformationResponse(.success(let user)):
        state.winnerName = user.nickName ?? ""
        return .none
        
      case ._fetchWinnerInformationResponse(.failure):
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
