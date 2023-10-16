//
//  SettingScene.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

import ComposableArchitecture

struct SettingScene: View {
  let store: StoreOf<SettingCore>
  
  var body: some View {
    VStack {
      IGONavigationBar {
        Text("설정")
          .font(.pretendard(size: 20, weight: .bold))
      } leftView: {
        Button {
          
        } label: {
          Image(systemName: "chevron.backward")
            .resizable()
            .frame(width: 12, height: 20)
        }
        .foregroundColor(ColorConstants.gray4)
      } rightView: {
        EmptyView()
      }
      
      WithViewStore(store, observe: \.settings) { viewStore in
        ScrollView {
          ForEach(viewStore.state, id: \.rawValue) { setting in
            Button {
              doingAction(to: viewStore, for: setting)
            } label: {
              HStack {
                Text(setting.description)
                
                Spacer()
              }
              .foregroundColor(setting.color)
            }
            .padding()
            .font(.pretendard(size: 16, weight: .semiBold))
          }
        }
      }
    }
    .padding(.horizontal, 24)
    .padding(.vertical, 16)
  }
  
  private func doingAction(
    to viewStore: ViewStore<[Setting], SettingCore.Action>,
    for actionType: Setting
  ) {
    switch actionType {
    case .logOut:
      viewStore.send(.signOut)
    case .withdraw:
      viewStore.send(.withdraw)
    default:
      return
    }
  }
}

#Preview {
  SettingScene(
    store: Store(
      initialState: SettingCore.State(),
      reducer: { SettingCore() }
    )
  )
}
