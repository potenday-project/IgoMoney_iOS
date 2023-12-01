//
//  ParticipatingChallengeResultSectionCore.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import ComposableArchitecture

struct ParticipatingChallengeResultSectionCore: Reducer {
  struct State: Equatable {
    let challenge: Challenge
    
    var myChallengeCost: ChallengeResultCore.State
    var competitorChallengeCost: ChallengeResultCore.State
    
    var currentUserID: Int = .zero
    var competitorUserID: Int = .zero
    
    var winnerDescription: String {
      let myCost = myChallengeCost.cost
      let competitorCost = competitorChallengeCost.cost
      
      if myCost == .zero && competitorCost == .zero {
        return "하루 지출 내역을 인증해주세요."
      }
      
      if myCost == competitorCost {
        return "현재 비기고 있는 중이예요 🤔"
      }
      
      let userName = myCost < competitorCost ? myChallengeCost.userNickName : competitorChallengeCost.userNickName
      return "현재 \(userName)님이 더 절약하고 있어요 🤔"
    }
    
    init(challenge: Challenge) {
      self.challenge = challenge
      self.myChallengeCost = ChallengeResultCore.State(challenge: challenge, isMine: true)
      self.competitorChallengeCost = ChallengeResultCore.State(challenge: challenge, isMine: false)
    }
  }
  
  enum Action: Equatable {
    case _setCurrentUserID(userID: Int)
    case _setCompetitorUserID(userID: Int)
    case myChallengeCostAction(ChallengeResultCore.Action)
    case competitorChallengeCostAction(ChallengeResultCore.Action)
  }
  
  @Dependency(\.userClient) var userClient
  @Dependency(\.challengeClient) var challengeClient
  
  var body: some Reducer<State, Action> {
    Scope(state: \.myChallengeCost, action: /Action.myChallengeCostAction) {
      ChallengeResultCore()
    }
    
    Scope(state: \.competitorChallengeCost, action: /Action.competitorChallengeCostAction) {
      ChallengeResultCore()
    }
    
    Reduce { state, action in
      switch action {
      case let ._setCurrentUserID(userID):
        state.currentUserID = userID
        return .none
        
      case let ._setCompetitorUserID(userID):
        state.competitorUserID = userID
        return .none
        
      case .myChallengeCostAction(._fetchUserNameResponse(.success(let user))):
        return .send(._setCurrentUserID(userID: user.userID))
        
      case .competitorChallengeCostAction(._fetchUserNameResponse(.success(let user))):
        return .send(._setCompetitorUserID(userID: user.userID))
        
      default:
        return .none
      }
    }
  }
}
