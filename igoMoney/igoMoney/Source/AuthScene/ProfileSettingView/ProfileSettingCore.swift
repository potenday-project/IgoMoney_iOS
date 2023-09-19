//
//  ProfileSettingCore.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import ComposableArchitecture

struct ProfileSettingCore: Reducer {
    struct State: Equatable {
        var nickName: String = ""
        var showNickNameConfirm: Bool = false
    }
    
    enum Action: Equatable {
        // User Action
        
        // Inner Action
        case _changeText(String)
        case _setShowNickNameConfirm
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case ._changeText(let nickName):
            let trimNickName = nickName.trimmingCharacters(in: .whitespacesAndNewlines)
            
            if trimNickName.count >= 8 { return .none }
            
            state.nickName = trimNickName
            
            return .run { send in
                await send(._setShowNickNameConfirm)
            }
            
        case ._setShowNickNameConfirm:
            let isAvailable = (3..<9) ~= state.nickName.count
            state.showNickNameConfirm = isAvailable
            return .none
        }
    }
}
