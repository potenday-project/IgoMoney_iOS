//
//  ProfileSettingCore.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import ComposableArchitecture

struct ProfileSettingCore: Reducer {
    struct State: Equatable {
        var nickName: String = ""
    }
    
    enum Action: Equatable {
        // User Action
        
        // Inner Action
        case _changeText(String)
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case ._changeText(let nickName):
            state.nickName = nickName
            return .none
        }
    }
}
