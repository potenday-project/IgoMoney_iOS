//
//  ProfileSettingView.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

import ComposableArchitecture

struct ProfileInitialSettingScene: View {
  let store: StoreOf<ProfileSettingCore>
  
  var body: some View {
    VStack(alignment: .leading, spacing: 24) {
      // Header View
      Text(TextConstants.nickNameTitle)
        .multilineTextAlignment(.leading)
        .font(.system(size: 20, weight: .bold))
        .padding(.top, 26)
        .padding(.horizontal, 24)
      
      // NickName Input Form
      VStack(alignment: .leading, spacing: 8) {
        InputHeaderView(
          title: TextConstants.nickName,
          detail: TextConstants.nickNameRuleText
        )
        
        NickNameInputView(
          placeholder: TextConstants.nickNamePlaceholder,
          store: self.store.scope(
            state: \.nickNameState,
            action: ProfileSettingCore.Action.nickNameDuplicateAction
          )
        )
      }
      .padding(.horizontal, 24)
      
      Spacer()
      
      // Start Challenge Button
      WithViewStore(store, observe: { $0 }) { viewStore in
        Button {
          viewStore.send(.startChallenge)
        } label: {
          HStack {
            Spacer()
            
            Text(TextConstants.startText)
            
            Spacer()
          }
        }
        .font(.system(size: 18, weight: .bold))
        .foregroundColor(
          viewStore.buttonEnable ? Color.black : ColorConstants.gray4
        )
        .padding(.vertical)
        .background(
          viewStore.buttonEnable ? ColorConstants.primary3 : ColorConstants.gray5
        )
        .cornerRadius(8)
        .padding([.horizontal, .bottom], 24)
        .disabled(viewStore.buttonEnable == false)
      }
    }
    .navigationBarHidden(false)
    .navigationBarTitleDisplayMode(.inline)
    .onAppear {
      UINavigationBar.appearance().tintColor = UIColor.gray.withAlphaComponent(0.3)
    }
  }
}

struct InputHeaderView: View {
  let title: String?
  let detail: String?
  
  var body: some View {
    HStack {
      if let title = title {
        Text(title)
          .font(.system(size: 18, weight: .bold))
      }
      
      Spacer()
      
      if let detail = detail {
        Text(detail)
          .font(.system(size: 12, weight: .medium))
          .foregroundColor(ColorConstants.gray3)
      }
    }
  }
}

struct ProfileSettingView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      ProfileInitialSettingScene(
        store: Store(
          initialState: ProfileSettingCore.State(),
          reducer: { ProfileSettingCore() }
        )
      )
    }
  }
}

private extension ProfileInitialSettingScene {
  enum TextConstants {
    static let nickNameTitle = "반가워요!\n닉네임을 설정해주세요."
    static let nickName = "닉네임"
    static let nickNameRuleText = "최소 3자 / 최대 8자"
    static let nickNamePlaceholder = "한글, 영어, 숫자만 사용가능합니다."
    
    static let startText = "챌린지 시작하기"
  }
}
