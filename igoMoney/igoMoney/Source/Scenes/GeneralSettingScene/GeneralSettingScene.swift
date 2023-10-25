//
//  SettingScene.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

import ComposableArchitecture

struct GeneralSettingScene: View {
  @Environment(\.presentationMode) var presentationMode
  let store: StoreOf<GeneralSettingCore>
  
  @ViewBuilder
  private func GeneralSettingCellWithContent(
    to setting: Setting,
    with viewStore: ViewStore<GeneralSettingCore.State, GeneralSettingCore.Action>
  ) -> some View {
    if setting == .authInformation || setting == .information {
      GeneralSettingCell(setting: setting) {
        Image(systemName: "chevron.forward")
      }
    }
    
    if setting == .serviceAlert {
      GeneralToggleCell(
        store: self.store.scope(
          state: \.serviceAlertState,
          action: GeneralSettingCore.Action.serviceAlertAction
        )
      )
    }
    
    if setting == .marketingAlert {
      GeneralToggleCell(
        store: self.store.scope(
          state: \.marketingAlertState,
          action: GeneralSettingCore.Action.marketingAlertAction
        )
      )
    }
    
    if setting == .appVersion {
      GeneralSettingCell(setting: .appVersion) {
        Text(viewStore.appVersion)
          .font(.pretendard(size: 14, weight: .bold))
          .foregroundColor(ColorConstants.primary3)
      }
    }
  }
  
  var body: some View {
    VStack {
      IGONavigationBar {
        Text("설정")
          .font(.pretendard(size: 20, weight: .bold))
      } leftView: {
        Button {
          presentationMode.wrappedValue.dismiss()
        } label: {
          Image(systemName: "chevron.backward")
            .resizable()
            .frame(width: 12, height: 20)
        }
      } rightView: {
        EmptyView()
      }
      .buttonStyle(.plain)
      
      ZStack {
        WithViewStore(store, observe: { $0 }) { viewStore in
          NavigationLink(
            isActive: viewStore.binding(
              get: \.showAuthSetting,
              send: GeneralSettingCore.Action.presentAuthSetting
            )
          ) {
            AuthSettingScene(
              store: self.store.scope(
                state: \.authSettingState,
                action: GeneralSettingCore.Action.authSettingAction
              )
            )
          } label: {
            EmptyView()
          }
        }
        
        ScrollView(.vertical, showsIndicators: false) {
          WithViewStore(store, observe: { $0 }) { viewStore in
            ForEach(viewStore.settings, id: \.rawValue) { setting in
              Button {
                if setting == .authInformation {
                  viewStore.send(.presentAuthSetting(true))
                }
              } label: {
                GeneralSettingCellWithContent(to: setting, with: viewStore)
              }
              .padding(.vertical, 16)
              .buttonStyle(.plain)
            }
          }
        }
      }
    }
    .onAppear {
      store.send(.onAppear)
    }
    .navigationBarHidden(true)
    .padding(.horizontal, 24)
    .padding(.vertical, 16)
  }
}

struct GeneralSettingCell<Content: View>: View {
  let setting: Setting
  let content: () -> Content
  
  init(setting: Setting, @ViewBuilder content: @escaping () -> Content) {
    self.setting = setting
    self.content = content
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      HStack {
        Text(setting.title)
          .font(.pretendard(size: 18, weight: .bold))
        
        Spacer()
        
        content()
      }
      
      if let subTitle = setting.subTitle {
        Text(subTitle)
          .font(.pretendard(size: 12, weight: .medium))
          .foregroundColor(ColorConstants.gray3)
      }
    }
  }
}

#Preview {
  GeneralSettingScene(
    store: Store(
      initialState: GeneralSettingCore.State(),
      reducer: { GeneralSettingCore() }
    )
  )
}
