//
//  ParticipatingChallengeCore.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import ComposableArchitecture

struct ParticipatingChallengeCore: Reducer {
  struct State: Equatable {
    var challenge: Challenge
    var challengeInformationState: ChallengeInformationCore.State
    var challengeResultSectionState: ParticipatingChallengeResultSectionCore.State
    var challengeAuthListState: ChallengeRecordSectionCore.State
    
    init(challenge: Challenge) {
      self.challenge = challenge
      self.challengeInformationState = ChallengeInformationCore.State(challenge: challenge)
      self.challengeResultSectionState = ParticipatingChallengeResultSectionCore.State(challenge: challenge)
      self.challengeAuthListState = ChallengeRecordSectionCore.State(challenge: challenge)
    }
  }
  
  enum Action: Equatable {
    case challengeInformationAction(ChallengeInformationCore.Action)
    case challengeResultSectionAction(ParticipatingChallengeResultSectionCore.Action)
    case challengeAuthListAction(ChallengeRecordSectionCore.Action)
  }
  
  var body: some Reducer<State, Action> {
    Scope(state: \.challengeInformationState, action: /Action.challengeInformationAction) {
      ChallengeInformationCore()
    }
    
    Scope(state: \.challengeResultSectionState, action: /Action.challengeResultSectionAction) {
      ParticipatingChallengeResultSectionCore()
    }
    
    Scope(state: \.challengeAuthListState, action: /Action.challengeAuthListAction) {
      ChallengeRecordSectionCore()
    }
    
    Reduce { state, action in
      switch action {
      case .challengeResultSectionAction(._setCurrentUserID(let userID)):
        return .send(.challengeAuthListAction(.setCurrentUserID(userID: userID)))
      case .challengeResultSectionAction(._setCompetitorUserID(let userID)):
        return .send(.challengeAuthListAction(.setCompetitorID(userID: userID)))
        
      default:
        return .none
      }
    }
  }
}
