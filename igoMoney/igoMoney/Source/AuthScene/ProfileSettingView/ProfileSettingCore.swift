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
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        // User Action
        case .confirmNickName:
            // TODO: - 사용자 닉네임 중복 API 호출
            guard let randomElement = [ConfirmState.duplicateNickName, ConfirmState.completeConfirm]
                .randomElement() else {
                return .none
            }
            state.nickNameState = randomElement
            return .none
            
        case .startChallenge:
            // TODO: - 로그인 후 화면 이동하기
            return .none
            
        // Inner Action
        case ._changeText(let nickName):
            let trimNickName = nickName.trimmingCharacters(in: .whitespacesAndNewlines)
            
            if trimNickName.count >= 8 || trimNickName.isEmpty { return .none }
            
            state.nickName = trimNickName
            
            return .run { send in
                await send(._setShowNickNameConfirm)
            }
            
        case ._setShowNickNameConfirm:
            state.nickNameState = .readyConfirm
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
