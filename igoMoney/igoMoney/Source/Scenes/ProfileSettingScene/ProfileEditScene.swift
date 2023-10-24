//
//  ProfileSettingScene.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI
import PhotosUI

import ComposableArchitecture

struct ProfileSettingScene: View {
  let store: StoreOf<ProfileSettingCore>
  
  private let imagePickerConfiguration: PHPickerConfiguration = {
    var configuration = PHPickerConfiguration(photoLibrary: .shared())
    configuration.filter = .images
    configuration.preferredAssetRepresentationMode = .compatible
    return configuration
  }()
  
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
          store.send(.complete)
        }
        .font(.pretendard(size: 16, weight: .bold))
      }
      .buttonStyle(.plain)
      .padding(.vertical, 24)
      
      WithViewStore(store, observe: { $0 }) { viewStore in
        URLImage(
          store: self.store.scope(
            state: \.profileImageState,
            action: ProfileSettingCore.Action.profileImageAction
          )
        )
        .scaledToFill()
        .frame(width: 90, height: 90)
        .clipShape(Circle())
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
        .onTapGesture {
          viewStore.send(.presentPhotoPicker(true))
        }
        .sheet(
          isPresented: viewStore.binding(
            get: \.presentPhotoPicker,
            send: ProfileSettingCore.Action.presentPhotoPicker
          )
        ) {
          IGOPhotoPicker(
            selectedImage: viewStore.binding(
              get: \.selectedImage,
              send: ProfileSettingCore.Action.selectImage
            ),
            configuration: imagePickerConfiguration
          )
        }
      }
      
      InputHeaderView(title: "닉네임", detail: "최소 3자 / 최대 8자")
      
      NickNameInputView(
        placeholder: "",
        store: self.store.scope(
          state: \.nickNameState,
          action: ProfileSettingCore.Action.nickNameDuplicateAction
        )
      )
      
      Spacer()
    }
    .navigationBarHidden(true)
    .padding(.horizontal, 24)
    .contentShape(Rectangle())
    .onTapGesture {
      UIApplication.shared.hideKeyboard()
    }
  }
}

#Preview {
  ProfileSettingScene(
    store: Store(
      initialState: ProfileSettingCore.State(profileImageState: .init(), nickNameState: .init()),
      reducer: { ProfileSettingCore() }
    )
  )
}
