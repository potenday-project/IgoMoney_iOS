//
//  ChallengeCore.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import ComposableArchitecture
import SwiftUI

struct ChallengeCore: Reducer {
    struct State: Equatable {
        var myChallengeState = MyChallengeSectionCore.State(color: .red)
        var emptyChallengeListState = EmptyChallengeListSectionCore.State()
    }
    
    enum Action {
        // Child Action
        case myChallengeAction(MyChallengeSectionCore.Action)
        case emptyChallengeAction(EmptyChallengeListSectionCore.Action)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .myChallengeAction:
                return .none
                
            case .emptyChallengeAction:
                return .none
            }
        }
        
        Scope(state: \.myChallengeState, action: /Action.myChallengeAction) {
            MyChallengeSectionCore()
        }
        
        Scope(state: \.emptyChallengeListState, action: /Action.emptyChallengeAction) {
            EmptyChallengeListSectionCore()
        }
    }
}
