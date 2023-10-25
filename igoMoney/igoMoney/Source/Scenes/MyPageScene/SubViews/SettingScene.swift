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
      } rightView: {
        EmptyView()
      }
      .buttonStyle(.plain)
      
      ScrollView(.vertical, showsIndicators: false) {
        WithViewStore(store, observe: { $0 }) { viewStore in
          ForEach(viewStore.settings, id: \.rawValue) { setting in
            Button {
              
            } label: {
              GeneralSettingCell(setting: setting) {
                switch setting.buttonType {
                case .general:
                  Image(systemName: "chevron.right")
                  
                case .toggle:
                  Text("토글 구현하기")
                  
                case .text:
                  Text("")
                }
              }
            }
            .padding(.vertical, 16)
            .buttonStyle(.plain)
          }
        }
      }
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
  SettingScene(
    store: Store(
      initialState: SettingCore.State(),
      reducer: { SettingCore() }
    )
  )
}
