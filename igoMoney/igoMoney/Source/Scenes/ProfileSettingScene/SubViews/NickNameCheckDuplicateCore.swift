//
//  NickNameCheckDuplicateCore.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import ComposableArchitecture

struct NickNameCheckDuplicateCore: Reducer {
  struct State: Equatable {
    var nickName: String = ""
    var nickNameState: ConfirmState = .disableConfirm
    var originNickName: String = ""
    
    var equalOrigin: Bool {
      return originNickName == nickName
    }
  }
  
  enum Action: Equatable {
    // User Action
    case confirmNickName
    case startChallenge
    
    // Inner Action
    case _changeText(String)
    case _setShowNickNameConfirm
    case _updateOriginNickName
    case _checkNickNameResponse(TaskResult<Bool>)
    case _updateNickNameResponse(TaskResult<Bool>)
  }
  
  @Dependency(\.userClient) var userClient
  
  func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
      // User Action
    case .confirmNickName:
      let nickName = state.nickName
      return .run { send in
        await send(
          ._checkNickNameResponse(
            TaskResult {
              try await userClient.checkNicknameDuplicate(nickName)
            }
          )
        )
      }
      
    case .startChallenge:
      return .run { [state] send in
        await send(
          ._updateNickNameResponse(
            TaskResult {
              try await userClient.updateUserInformation(state.nickName, nil)
            }
          )
        )
      }
      
      // Inner Action
    case ._changeText(let nickName):
      let trimNickName = nickName.trimmingCharacters(in: .whitespacesAndNewlines)
      
      state.nickName = trimNickName
      
      return .run { send in
        await send(._setShowNickNameConfirm)
      }
      
    case ._setShowNickNameConfirm:
      if state.equalOrigin {
        state.nickNameState = .disableConfirm
        return .none
      }
      
      let count = state.nickName.count
      let status: ConfirmState = ((3...8) ~= count) ? .readyConfirm : .disableConfirm
      state.nickNameState = status
      return .none
      
    case ._checkNickNameResponse(.success(let isConfirm)):
      if isConfirm {
        state.nickNameState = .completeConfirm
      } else {
        state.nickNameState = .duplicateNickName
      }
      
      return .none
      
    case ._checkNickNameResponse(.failure):
      state.nickNameState = .duplicateNickName
      return .none
      
    case ._updateNickNameResponse(.success):
      return .send(._updateOriginNickName)
      
    case ._updateNickNameResponse:
      return .none
      
    case ._updateOriginNickName:
      state.originNickName = state.nickName
      return .none
    }
  }
}
