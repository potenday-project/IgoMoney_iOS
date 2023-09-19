//
//  SignUpCore.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import ComposableArchitecture

struct SignUpCore: Reducer {
    struct State: Equatable {
        var isAgreePrivacy: Bool = false
        var isAgreeTerms: Bool = false
        
        var isAgreeAll: Bool {
            return isAgreePrivacy && isAgreeTerms
        }
    }
    
    enum Action: Equatable {
        case didTapAll
        case didTapAgreePrivacy
        case didTapAgreeTerms
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .didTapAll:
            if state.isAgreePrivacy && state.isAgreeTerms {
                state.isAgreePrivacy.toggle()
                state.isAgreeTerms.toggle()
                return .none
            }
            
            if state.isAgreePrivacy == false {
                state.isAgreePrivacy.toggle()
            }
            
            if state.isAgreeTerms == false {
                state.isAgreeTerms.toggle()
            }
            
            return .none
            
        case .didTapAgreePrivacy:
            state.isAgreePrivacy.toggle()
            return .none
            
        case .didTapAgreeTerms:
            state.isAgreePrivacy.toggle()
            return .none
            
        default: return .none
        }
    }
}
