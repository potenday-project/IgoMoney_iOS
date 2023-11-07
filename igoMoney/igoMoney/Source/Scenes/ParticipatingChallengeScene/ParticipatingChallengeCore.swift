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
    var challengeAuthListState: ChallengeAuthListCore.State
    
    init(challenge: Challenge) {
      self.challenge = challenge
      self.challengeInformationState = ChallengeInformationCore.State(challenge: challenge)
      self.challengeResultSectionState = ParticipatingChallengeResultSectionCore.State(challenge: challenge)
      self.challengeAuthListState = ChallengeAuthListCore.State(challenge: challenge)
    }
  }
  
  enum Action: Equatable {
    case challengeInformationAction(ChallengeInformationCore.Action)
    case challengeResultSectionAction(ParticipatingChallengeResultSectionCore.Action)
    case challengeAuthListAction(ChallengeAuthListCore.Action)
  }
  
  var body: some Reducer<State, Action> {
    Scope(state: \.challengeInformationState, action: /Action.challengeInformationAction) {
      ChallengeInformationCore()
    }
    
    Scope(state: \.challengeResultSectionState, action: /Action.challengeResultSectionAction) {
      ParticipatingChallengeResultSectionCore()
    }
    
    Scope(state: \.challengeAuthListState, action: /Action.challengeAuthListAction) {
      ChallengeAuthListCore()
    }
    
    Reduce { state, action in
      switch action {
      default:
        return .none
      }
    }
  }
}
