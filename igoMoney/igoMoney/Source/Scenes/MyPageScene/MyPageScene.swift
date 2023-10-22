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
    VStack(spacing: .zero) {
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
      .padding(.horizontal, 24)
      .padding(.top, 16)
      
      ScrollView(.vertical, showsIndicators: false) {
        VStack(spacing: 24) {
          UserProfileSection(
            store: store.scope(
              state: \.profileState,
              action: MyPageCore.Action.userProfileAction
            )
          )
          
          VStack(spacing: 12) {
            Section(header: sectionHeaderView(title: "챌린지 현황")) {
              RoundedRectangle(cornerRadius: 20)
                .frame(height: 76 + 110)
            }
          }
          
          VStack(spacing: 12) {
            Section(header: sectionHeaderView(title: "고객 지원")) {
              WithViewStore(store, observe: { $0 }) { viewStore in
                CustomServiceSection(viewStore: viewStore)
              }
            }
          }
          
          Spacer()
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
      }
    }
    .shareSheet(
      ViewStore(store, observe: { $0 })
        .binding(get: \.shareItem, send: MyPageCore.Action._presentShare)
    )
  }
}

struct CustomServiceSection: View {
  let viewStore: ViewStoreOf<MyPageCore>
  
  @ViewBuilder
  private func customServiceCell(to service: CustomerServiceType) -> some View {
    HStack(spacing: 12) {
      Image(service.iconName)
      
      Text(service.description)
      
      Spacer()
    }
    .font(.pretendard(size: 16, weight: .semiBold))
    .padding(16)
  }
  
  var body: some View {
    VStack(spacing: .zero) {
      ForEach(viewStore.customServices, id: \.rawValue) { service in
        VStack(spacing: .zero) {
          Button {
            viewStore.send(.tapService(service))
          } label: {
            customServiceCell(to: service)
          }
          .buttonStyle(.plain)
          
          Divider()
        }
      }
    }
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
