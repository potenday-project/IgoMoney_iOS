//
//  ExploreChallengeCore.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

import ComposableArchitecture

struct ExploreChallengeCore: Reducer {
    struct State: Equatable {
        var challenges: IdentifiedArrayOf<ChallengeDetailCore.State> = []
    }
    
    enum Action: Equatable {
        case _onAppear
        case detailAction(id: ChallengeDetailCore.State.ID, action: ChallengeDetailCore.Action)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            // Inner Action
            case ._onAppear:
                let defaultValues = ChallengeInformation.default
                defaultValues.forEach {
                    let detailState = ChallengeDetailCore.State(
                        id: UUID(),
                        title: $0.title,
                        content: $0.content,
                        targetAmount: $0.targetAmount,
                        user: $0.user
                    )
                    state.challenges.append(detailState)
                }
                
                return .none
                
            // Child Action
            case .detailAction:
                return .none
            }
        }
        .forEach(\.challenges, action: /Action.detailAction) {
            ChallengeDetailCore()
        }
    }
}
