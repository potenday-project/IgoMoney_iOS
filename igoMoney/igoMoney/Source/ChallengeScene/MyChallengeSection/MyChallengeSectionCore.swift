//
//  MyChallengeSectionCore.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

import ComposableArchitecture

struct MyChallengeSectionCore: Reducer {
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

