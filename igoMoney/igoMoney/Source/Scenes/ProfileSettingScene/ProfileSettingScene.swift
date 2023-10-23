//
//  ProfileSettingScene.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

import ComposableArchitecture

struct ProfileSettingScene: View {
  let store: StoreOf<ProfileSettingCore>
  
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
      .padding(.vertical, 24)
      
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
      
      InputHeaderView(title: "닉네임", detail: "최소 3자 / 최대 8자")
      
      WithViewStore(store, observe: { $0 }) { viewStore in
        InputFormView(
          placeholder: "",
          viewStore: viewStore
        )
      }
      
      WithViewStore(store, observe: { $0 }) { viewStore in
        HStack {
          Text(viewStore.nickNameState.description)
            .font(.system(size: 12, weight: .medium))
            .foregroundColor(
              viewStore.nickNameState == .duplicateNickName ? Color.red : .black
            )
          
          Spacer()
        }
      }
      
      Spacer()
    }
    .padding(.horizontal, 24)
    .onTapGesture {
      UIApplication.shared.hideKeyboard()
    }
    .navigationBarHidden(true)
  }
}

#Preview {
  ProfileSettingScene(
    store: Store(
      initialState: ProfileSettingCore.State(),
      reducer: { ProfileSettingCore() }
    )
  )
}
