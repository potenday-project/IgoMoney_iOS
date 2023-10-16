//
//  ContentView.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

import ComposableArchitecture

struct MainScene: View {
  let store: StoreOf<MainCore>
  
  private let shadowConfiguration = ShadowConfiguration(
    color: ColorConstants.gray.opacity(0.5),
    radius: 5,
    x: .zero,
    y: 5
  )
  
  var body: some View {
    NavigationView {
      ZStack {
        Color.white
          .edgesIgnoringSafeArea(.all)
        
        WithViewStore(store, observe: { $0 }) { viewStore in
          IGORoundTabBar(
            selectedTab: viewStore.binding(
              get: \.selectedTab,
              send: MainCore.Action.selectedTabChange
            ),
            shadowSetting: shadowConfiguration
          ) {
            
            switch viewStore.selectedTab {
            case .home:
              HomeScene(
                store: store.scope(
                  state: \.challengeState,
                  action: MainCore.Action.challengeAction
                )
              )
              
            case .myPage:
              MyPageScene(
                store: store.scope(
                  state: \.myPageState,
                  action: MainCore.Action.myPageAction
                )
              )
            }
          }
        }
      }
      .navigationBarHidden(true)
    }
    .navigationViewStyle(.stack)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    MainScene(
      store: Store(
        initialState: MainCore.State(),
        reducer: { MainCore() }
      )
    )
  }
}
