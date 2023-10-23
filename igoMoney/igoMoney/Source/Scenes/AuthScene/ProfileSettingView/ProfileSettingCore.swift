//
//  ProfileSettingCore.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import ComposableArchitecture

struct ProfileSettingCore: Reducer {
  struct State: Equatable {
    var nickNameState = NickNameCheckDuplicateCore.State()
    var buttonEnable: Bool = false
  }
  
  enum Action: Equatable {
    case startChallenge
    // Child Action
    case nickNameDuplicateAction(NickNameCheckDuplicateCore.Action)
  }
  
  @Dependency(\.userClient) var userClient
  
  var body: some Reducer<State, Action> {
    Scope(state: \.nickNameState, action: /Action.nickNameDuplicateAction) {
      NickNameCheckDuplicateCore()
    }
    
    Reduce { state, action in
      switch action {
      case .startChallenge:
        return .none
        
      case .nickNameDuplicateAction(._checkNickNameResponse(.success)):
        state.buttonEnable = true
        return .none
        
      case .nickNameDuplicateAction:
        return .none
      }
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
