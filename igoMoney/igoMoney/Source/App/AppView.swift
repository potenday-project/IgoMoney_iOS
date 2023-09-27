//
//  AppView.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

import ComposableArchitecture

struct AppView: View {
  let store: StoreOf<AppCore>
  
  var body: some View {
    SwitchStore(store) { state in
      switch state {
      case .logIn:
        CaseLet(
          /AppCore.State.logIn,
          action: AppCore.Action.mainAction
        ) { store in
          MainScene(store: store)
        }
        
      case .logOut:
        CaseLet(
          /AppCore.State.logOut,
          action: AppCore.Action.authAction
        ) { store in
          AuthScene(store: store)
        }
      }
    }
  }
}

#Preview ("App View") {
  AppView(
    store: Store(
      initialState: AppCore.State.logOut(.init()),
      reducer: { AppCore() }
    )
  )
}
