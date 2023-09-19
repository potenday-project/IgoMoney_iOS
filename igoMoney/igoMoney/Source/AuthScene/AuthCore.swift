//
//  AuthCore.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import ComposableArchitecture

struct AuthCore: Reducer {
    struct State: Equatable {
        let providers: [Provider] = Provider.allCases
        var showSignUp: Bool = false
        
        var signUpState: SignUpCore.State?
    }
    
    enum Action: Equatable {
        // User Action
        case presentSignUp(Bool)
        case didTapKakaoLogin
        
        // Child Action
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
                
            case .signUpAction(.didTapConfirm):
                return .run { send in
                    await send(.presentSignUp(false))
                }
                
            default:
                return .none
            }
        }
        .ifLet(\.signUpState, action: /Action.signUpAction) {
            SignUpCore()
        }
    }
}
