//
//  AuthCore.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import ComposableArchitecture

struct AuthCore: Reducer {
    struct State: Equatable {
        var helpState = HelpScrollCore.State()
        var showSignUp: Bool = false
        
        var signUpState: SignUpCore.State?
    }
    
    enum Action: Equatable {
        // User Action
        case presentSignUp(Bool)
        case didTapKakaoLogin
        
        // Child Action
        case helpAction(HelpScrollCore.Action)
        case signUpAction(SignUpCore.Action)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .didTapKakaoLogin:
                return .run { send in
                   await send(.presentSignUp(true))
                }
                
            case .presentSignUp(true):
                state.showSignUp = true
                state.signUpState = SignUpCore.State()
                return .none
                
            case .presentSignUp(false):
                state.showSignUp = false
                state.signUpState = nil
                return .none
                
            default:
                return .none
            }
        }
        .ifLet(\.signUpState, action: /Action.signUpAction) {
            SignUpCore()
        }
        
        Scope(state: \.helpState, action: /Action.helpAction) {
            HelpScrollCore()
        }
    }
}
