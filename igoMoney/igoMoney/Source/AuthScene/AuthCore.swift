//
//  AuthCore.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import ComposableArchitecture

struct AuthCore: Reducer {
    struct State: Equatable {
        var helpState = HelpScrollCore.State()
    }
    
    enum Action: Equatable {
        case helpAction(HelpScrollCore.Action)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            default:
                return .none
            }
        }
        
        Scope(state: \.helpState, action: /Action.helpAction) {
            HelpScrollCore()
        }
    }
}
