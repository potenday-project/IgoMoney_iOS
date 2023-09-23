//
//  ProfileSettingView.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

import ComposableArchitecture

struct ProfileSettingView: View {
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
        
        WithViewStore(store, observe: { $0 }) { viewStore in
          InputFormView(
            placeholder: TextConstants.nickNamePlaceholder,
            viewStore: viewStore
          )
        }
        
        WithViewStore(store, observe: { $0 }) { viewStore in
          Text(viewStore.nickNameState.description)
            .font(.system(size: 12, weight: .medium))
            .foregroundColor(
              viewStore.nickNameState == .duplicateNickName ? Color.red : .black
            )
        }
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
          viewStore.nickNameState == .completeConfirm ?
          Color.black : ColorConstants.gray4
        )
        .padding(.vertical)
        .background(
          viewStore.nickNameState == .completeConfirm ?
          ColorConstants.primary3 : ColorConstants.gray5
        )
        .cornerRadius(8)
        .padding([.horizontal, .bottom], 24)
        .disabled(viewStore.nickNameState != .completeConfirm)
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

struct InputFormView: View {
  let placeholder: String
  
  let viewStore: ViewStoreOf<ProfileSettingCore>
  
  var body: some View {
    HStack {
      TextField(
        placeholder,
        text: viewStore.binding(
          get: \.nickName,
          send: ProfileSettingCore.Action._changeText
        )
      )
      .font(.system(size: 16, weight: .medium))
      
      Button {
        viewStore.send(.confirmNickName)
      } label: {
        Text(TextConstants.confirmDuplicateText)
      }
      .font(.system(size: 12, weight: .medium))
      .foregroundColor(
        viewStore.nickNameState == .disableConfirm ? ColorConstants.gray4 : .white
      )
      .padding(.horizontal, 8)
      .padding(.vertical, 5)
      .background(
        viewStore.nickNameState == .disableConfirm ?
        ColorConstants.gray4 : viewStore.nickNameState == .completeConfirm ?
        ColorConstants.primary3 : ColorConstants.primary
      )
      .cornerRadius(.infinity)
      .opacity(viewStore.nickNameState == .disableConfirm ? .zero : 1)
      .disabled(viewStore.nickNameState == .disableConfirm)
    }
    .padding(12)
    .background(ColorConstants.primary7)
    .cornerRadius(8)
  }
  
}

struct ProfileSettingView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      ProfileSettingView(
        store: Store(
          initialState: ProfileSettingCore.State(),
          reducer: { ProfileSettingCore() }
        )
      )
    }
  }
}

private extension ProfileSettingView {
  enum TextConstants {
    static let nickNameTitle = "반가워요!\n닉네임을 설정해주세요."
    static let nickName = "닉네임"
    static let nickNameRuleText = "최소 3자 / 최대 8자"
    static let nickNamePlaceholder = "한글, 영어, 숫자만 사용가능합니다."
    
    static let startText = "챌린지 시작하기"
  }
}

private extension InputFormView {
  enum TextConstants {
    static let confirmDuplicateText = "중복확인"
  }
}
