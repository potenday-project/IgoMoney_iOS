//
//  EnterChallengeCore.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import ComposableArchitecture

struct EnterChallengeCore: Reducer {
  struct State: Equatable {
    let challenge: Challenge
    var showAlert: Bool = false
    var showProgressView: Bool = false
    
    var leader: User?
    
    var leaderID: String {
      return challenge.leaderID.description
    }
  }
  
  enum Action: Equatable {
    // User Action
    case enterChallenge
    case dismiss
    case setShowAlert(Bool)
    
    // Inner Action
    case _onAppear
    case _closeAlert
    case _fetchLeaderResponse(TaskResult<User>)
  }
  
  @Dependency(\.userClient) var userClient
  
  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .enterChallenge:
        // TODO: - 사용자 입장 메서드 수행
        state.showProgressView = true
        return .run { send in
          await send(.setShowAlert(false))
        }
        
      case .dismiss:
        return .none
        
      case .setShowAlert(true):
        state.showAlert = true
        return .none
        
      case .setShowAlert(false):
        state.showAlert = false
        return .none
        
      case ._onAppear:
        return .run { [leaderID = state.leaderID] send in
            await send(
              ._fetchLeaderResponse(
                TaskResult {
                  try await userClient.getUserInformation(leaderID)
                }
              )
            )
        }
        
      case ._closeAlert:
        state.showAlert = false
        return .none
        
      case ._fetchLeaderResponse(.success(let leader)):
        state.leader = leader
        return .none
        
      case ._fetchLeaderResponse(.failure):
        return .none
      }
    }
  }
}
