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
        var selectedMoney: MoneyType = .all
    }
    
    enum Action: Equatable {
        // User Action
        case selectMoney(MoneyType)
        
        // Inner Action
        case _onAppear
        
        // Child Action
        case detailAction(id: ChallengeDetailCore.State.ID, action: ChallengeDetailCore.Action)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            // User Action
            case .selectMoney(let moneyType):
                state.selectedMoney = moneyType
                return .none
                
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
