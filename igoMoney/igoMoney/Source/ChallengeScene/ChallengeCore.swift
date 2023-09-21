//
//  ChallengeCore.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import ComposableArchitecture
import SwiftUI

struct ChallengeCore: Reducer {
    struct State: Equatable {
        var myChallengeState = MyChallengeCore.State(color: .red)
    }
    
    enum Action {
        case myChallengeAction(MyChallengeCore.Action)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .myChallengeAction:
                return .none
            }
        }
        
        Scope(state: \.myChallengeState, action: /Action.myChallengeAction) {
            MyChallengeCore()
        }
    }
}

struct MyChallengeCore: Reducer {
    struct State: Equatable {
        var color: Color // Action Test 용
    }
    
    enum Action: Equatable {
        case changeColor(Color)
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .changeColor(let color):
            state.color = color
            return .none
        }
    }
}
