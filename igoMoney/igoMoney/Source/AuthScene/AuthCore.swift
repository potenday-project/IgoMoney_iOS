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
        var isNavigationBarHidden: Bool = true
        var showProfileSetting: Bool = false
        
        var signUpState: SignUpCore.State?
//        var profileSettingState
    }
    
    enum Action: Equatable {
        // User Action
        case presentSignUp(Bool)
        case presentProfileSetting(Bool)
        case didTapLoginButton(Provider)
        
        // Inner Action
        case _loginWithKakao
        case _loginWithApple
        
        // Child Action
        case signUpAction(SignUpCore.Action)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            // User Action
            case .didTapLoginButton(let provider):
                switch provider {
                case .kakao:
                    return .run { send in
                        await send(._loginWithKakao)
                    }
                    
                case .apple:
                    return .run { send in
                        await send(._loginWithApple)
                    }
                }
                
            case .presentSignUp(true):
                state.showSignUp = true
                state.signUpState = SignUpCore.State()
                return .none
                
            case .presentSignUp(false):
                state.showSignUp = false
                state.signUpState = nil
                return .none
                
            case .presentProfileSetting(true):
                return .none
                
            case .presentProfileSetting(false):
                state.showProfileSetting = false
                return .none
            
            // Inner Action
            case ._loginWithKakao:
                return .run { send in
                    await send(.presentSignUp(true))
                }
                
            case ._loginWithApple:
                return .run { send in
                    await send(.presentSignUp(true))
                }
                
            // Child Action
            case .signUpAction(.didTapConfirm):
                state.showProfileSetting = true
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
