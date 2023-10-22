//
//  MyPageScene.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

import ComposableArchitecture

struct MyPageScene: View {
  let store: StoreOf<MyPageCore>
  
  @ViewBuilder
  private func sectionHeaderView(title: String) -> some View {
    HStack {
      Text(title)
      
      Spacer()
    }
    .font(.pretendard(size: 18, weight: .bold))
  }
  
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
      
      Section(header: sectionHeaderView(title: "챌린지 현황")) {
        RoundedRectangle(cornerRadius: 20)
          .frame(height: 76 + 110)
      }
      
      Section(header: sectionHeaderView(title: "고객 지원")) {
        VStack(spacing: .zero) {
          ForEach(1...4, id: \.self) { _ in
            VStack {
              HStack {
                Image(systemName: "pencil")
                
                Text("앱 공유하기")
                
                Spacer()
              }
              .font(.pretendard(size: 16, weight: .semiBold))
              .padding(16)
              
              Divider()
            }
          }
        }
      }
      
      Spacer()
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
