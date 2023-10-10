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
    case _enterChallengeResponse(TaskResult<Bool>)
  }
  
  @Dependency(\.userClient) var userClient
  @Dependency(\.challengeClient) var challengeClient
  
  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .enterChallenge:
        // TODO: - 사용자 입장 메서드 수행
        state.showProgressView = true
        return .run { [challengeID = state.challenge.id] send in
          await send(
            ._enterChallengeResponse(
              TaskResult {
                try await challengeClient.enterChallenge(challengeID.description)
              }
            )
          )
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
        
      case ._enterChallengeResponse(.success):
        state.showProgressView = false
        return .run { send in
          await send(._closeAlert)
        }
        
      case ._enterChallengeResponse(.failure(let error)):
        if case let .badRequest(statusCode) = error as? APIError {
          if statusCode == 409 {
            // 이미 챌린지를 가지고 있는 경우 - 버튼 비활성화
          }
          
          if statusCode == 404 {
            // 알수 없는 오류 발생 (사용자 나 챌린지의 정보가 잘못됨
          }
        }
        return .none
      }
    }
  }
}
