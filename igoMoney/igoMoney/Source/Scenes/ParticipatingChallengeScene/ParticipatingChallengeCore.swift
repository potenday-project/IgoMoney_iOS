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
    var selectedChallengeRecordState: ChallengeRecordDetailCore.State?
    var declarationTargetState: DeclarationCore.State?
    var showDeclaration: Bool = false
    var isSelected: Bool {
      return selectedChallengeRecordState != nil
    }
    
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
    case selectedChallengeRecordAction(ChallengeRecordDetailCore.Action)
    case declarationTargetAction(DeclarationCore.Action)
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
        
      case .challengeAuthListAction(._presentRecordDialog(let record)):
        state.selectedChallengeRecordState = record
        return .none
        
      case .selectedChallengeRecordAction(.onDisappear):
        state.selectedChallengeRecordState = nil
        return .concatenate(
          .send(.challengeResultSectionAction(.myChallengeCostAction(.onAppear))),
          .send(.challengeResultSectionAction(.competitorChallengeCostAction(.onAppear))),
          .send(.challengeAuthListAction(.fetchRecords))
        )
        
      case .selectedChallengeRecordAction(.showDeclarationView(true)):
        guard let selectedRecord = state.selectedChallengeRecordState?.record else {
          return .none
        }
        
        state.showDeclaration = true
        state.declarationTargetState = DeclarationCore.State(record: selectedRecord)
        return .none
        
      case .selectedChallengeRecordAction(.showDeclarationView(false)):
        state.showDeclaration = false
        state.declarationTargetState = nil
        return .none
        
      case .declarationTargetAction(.dismissView):
        state.selectedChallengeRecordState = nil
        
        state.showDeclaration = false
        state.declarationTargetState = nil
        return .send(.challengeAuthListAction(.fetchRecords))
        
      default:
        return .none
      }
    }
    .ifLet(\.selectedChallengeRecordState, action: /Action.selectedChallengeRecordAction) {
      ChallengeRecordDetailCore()
    }
    .ifLet(\.declarationTargetState, action: /Action.declarationTargetAction) {
      DeclarationCore()
    }
  }
}
