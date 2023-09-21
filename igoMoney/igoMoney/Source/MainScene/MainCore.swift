//
//  MainCore.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import ComposableArchitecture

struct MainCore: Reducer {
    struct State: Equatable {
        var selectedTab: MainTab = .challenge
    }
    
    enum Action {
        case selectedTabChange(MainTab)
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .selectedTabChange(let tab):
            state.selectedTab = tab
            return .none
        }
    }
}
