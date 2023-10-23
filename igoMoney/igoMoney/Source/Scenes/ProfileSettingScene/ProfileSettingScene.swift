//
//  ProfileSettingScene.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

import ComposableArchitecture

struct ProfileSettingScene: View {
  var body: some View {
    VStack(alignment: .center) {
      IGONavigationBar {
        Text("프로필 수정")
          .font(.pretendard(size: 20, weight: .bold))
      } leftView: {
        Button {
          
        } label: {
          Image(systemName: "chevron.backward")
        }
        .font(.pretendard(size: 16, weight: .bold))
      } rightView: {
        Button("수정") {
          
        }
        .font(.pretendard(size: 16, weight: .bold))
      }
      .buttonStyle(.plain)
      .padding(24)
      
      Button {
        print("Tapped image Button")
      } label: {
        Image("default_profile")
          .resizable()
          .frame(maxWidth: 90, maxHeight: 90)
          .overlay(
            Image("icon_camera")
              .padding(6)
              .foregroundColor(.white)
              .background(
                Circle()
                  .fill(ColorConstants.primary)
              )
            ,
            alignment: .bottomTrailing
          )
      }
      .buttonStyle(.plain)
      
//      InputFormView(
//        placeholder: "",
//        viewStore: <#T##ViewStoreOf<ProfileSettingCore>#>
//      )
      
      Spacer()
    }
  }
}

#Preview {
  ProfileSettingScene()
}
