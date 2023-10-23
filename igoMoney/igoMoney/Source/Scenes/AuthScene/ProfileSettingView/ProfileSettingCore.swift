//
//  ProfileSettingCore.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import ComposableArchitecture

struct ProfileSettingCore: Reducer {
  struct State: Equatable {
    var nickName: String = ""
    var nickNameState: ConfirmState = .disableConfirm
  }
  
  enum Action: Equatable {
    // User Action
    case confirmNickName
    case startChallenge
    
    // Inner Action
    case _changeText(String)
    case _setShowNickNameConfirm
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
              try await userClient.updateUserInformation(state.nickName)
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
      
    case ._updateNickNameResponse:
      return .none
    }
  }
}

enum ConfirmState: CustomStringConvertible {
  case disableConfirm
  case readyConfirm
  case duplicateNickName
  case completeConfirm
  
  var description: String {
    switch self {
    case .disableConfirm:
      return TextConstants.baseHelpText
    case .readyConfirm:
      return TextConstants.confirmHelpText
    case .duplicateNickName:
      return TextConstants.duplicateNickName
    case .completeConfirm:
      return ""
    }
  }
}

private extension ConfirmState {
  enum TextConstants {
    static let baseHelpText = "최소 3자 이상의 영문, 한글 숫자만 입력해주세요."
    static let confirmHelpText = "중복확인 버튼을 눌러주세요."
    static let duplicateNickName = "중복된 닉네임입니다. 다른 닉네임을 사용해주세요."
  }
}
