//
//  AppView.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

import ComposableArchitecture

struct AppScene: View {
  let store: StoreOf<AppCore>
  
  var body: some View {
    WithViewStore(store, observe: { $0.currentState }) { viewStore in
      if viewStore.state == .onBoarding {
        ZStack {
          Color("background_color")
            .edgesIgnoringSafeArea(.all)
          
          Image("icon_launch")
        }
      }
      
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
    .onAppear {
      store.send(._onAppear)
    }
  }
}

#Preview ("AppScene") {
  Group {
    AppScene(
      store: Store(
        initialState: AppCore.State(currentState: .onBoarding),
        reducer: { AppCore() }
      )
    )
  }
}
