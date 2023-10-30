//
//  MyChallengeSectionCore.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

import ComposableArchitecture

struct MyChallengeSectionCore: Reducer {
  struct State: Equatable {
    var userChallenge: ChallengeStatus = .notInChallenge
    var participatingChallenge: ParticipatingChallengeCore.State?
  }
  
  enum Action: Equatable {
    case _onAppear
    case _myChallengeResponse(TaskResult<Challenge>)
    
    case participatingChallengeAction(ParticipatingChallengeCore.Action)
  }
  
  @Dependency(\.challengeClient) var challengeClient
  
  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
        
      case ._onAppear:
        return .run { send in
          await send(
            ._myChallengeResponse(
              TaskResult {
                try await challengeClient.getMyChallenge()
              }
            )
          )
        }
        
      case ._myChallengeResponse(.success(let challenge)):
        if challenge.competitorID == nil {
          state.userChallenge = .waitingUser(challenge)
          return .none
        }
        
        if challenge.isStart == false {
          state.userChallenge = .waitingStart(challenge)
          return .none
        }
        
        state.userChallenge = .processingChallenge(challenge)
        state.participatingChallenge = ParticipatingChallengeCore.State(challenge: challenge)
        return .none
        
      case ._myChallengeResponse(.failure(let error as APIError)):
        // 챌린지가 없는 경우 또는 에러가 발생한 경우
        if case APIError.badRequest(409) = error {
          state.userChallenge = .notInChallenge
        }
        
        return .none
        
      default:
        return .none
      }
    }
    .ifLet(\.participatingChallenge, action: /Action.participatingChallengeAction) {
      ParticipatingChallengeCore()
    }
  }
}
