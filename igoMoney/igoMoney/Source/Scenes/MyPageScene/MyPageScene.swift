//
//  MyPageScene.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

import ComposableArchitecture

struct MyPageScene: View {
  let store: StoreOf<MyPageCore>
  
  var body: some View {
    VStack(spacing: 24) {
      WithViewStore(store, observe: { $0 }) { viewStore in
        IGONavigationBar {
          EmptyView()
        } leftView: {
          Text("마이페이지")
            .font(.pretendard(size: 20, weight: .bold))
        } rightView: {
          NavigationLink(
            destination: SettingScene(
              store: store.scope(
                state: \.settingState,
                action: MyPageCore.Action.settingAction
              )
            ),
            label: {
              Image("icon_gear")
            }
          )
        }
      }
      
      UserProfileSection(
        store: store.scope(
          state: \.profileState,
          action: MyPageCore.Action.userProfileAction
        )
      )
    }
    .padding(.horizontal, 24)
    .padding(.vertical, 16)
  }
}

#Preview {
  NavigationView {
    MyPageScene(
      store: Store(
        initialState: MyPageCore.State(),
        reducer: { MyPageCore() }
      )
    )
    .navigationBarHidden(true)
  }
  .navigationViewStyle(.stack)
}
