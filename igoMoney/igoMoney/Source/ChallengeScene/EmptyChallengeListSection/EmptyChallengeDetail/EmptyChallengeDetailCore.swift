//
//  EmptyChallengeDetailCore.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

import ComposableArchitecture

struct ChallengeDetailCore: Reducer {
    struct State: Equatable, Identifiable {
        let id: UUID
        
        var title: String
        var content: String
        var targetAmount: Int
        var user: User
        
        var targetMoneyDescription: String {
            return "💸 \(targetAmount)원"
        }
    }
    
    enum Action: Equatable, Sendable {
        
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        return .none
    }
}

