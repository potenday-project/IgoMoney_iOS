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
    WithViewStore(store, observe: { $0.currentState }) { viewStore in
      if viewStore.state == .auth {
        AuthScene(
          store: self.store.scope(
            state: \.authState,
            action: AppCore.Action.authAction
          )
        )
      }
      
      if viewStore.state == .main {
        MainScene(
          store: self.store.scope(
            state: \.mainState,
            action: AppCore.Action.mainAction
          )
        )
      }
    }
  }
}

#Preview ("App View") {
  AppView(
    store: Store(
      initialState: AppCore.State(),
      reducer: { AppCore() }
    )
  )
}
