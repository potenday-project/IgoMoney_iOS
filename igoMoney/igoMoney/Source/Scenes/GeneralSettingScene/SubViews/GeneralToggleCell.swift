//
//  GeneralToggleCell.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

import ComposableArchitecture

struct GeneralToggleReducer: Reducer {
  struct State: Equatable {
    let setting: Setting
    
    var isActive: Bool = true
  }
  
  enum Action: Equatable {
    case toggle(Bool)
  }
  
  func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case .toggle(let isActive):
      state.isActive = isActive
      return .none
    }
  }
}

struct GeneralToggleCell: View {
  let store: StoreOf<GeneralToggleReducer>
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      GeneralSettingCell(setting: viewStore.setting) {
        Toggle(
          "",
          isOn: viewStore.binding(
            get: \.isActive,
            send: GeneralToggleReducer.Action.toggle
          )
        )
        .toggleStyle(IGOToggleStyle())
      }
    }
  }
}
