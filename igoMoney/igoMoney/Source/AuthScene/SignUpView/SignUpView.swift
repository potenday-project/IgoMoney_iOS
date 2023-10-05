//
//  SignUpView.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

import ComposableArchitecture

struct SignUpView: View {
  let store: StoreOf<SignUpCore>
  @Environment(\.openURL) var openURLAction
  
  @ViewBuilder
  private func informationBaseView(with text: String) -> some View {
    HStack {
      Text(text)
      
      Spacer()
    }
  }
  
  private func openURL(to urlString: String) {
    guard let url = URL(string: urlString) else { return }
    self.openURLAction(url)
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: .zero) {
      VStack(spacing: 4) {
        informationBaseView(with: TextConstants.title)
          .font(.pretendard(size: 18, weight: .bold))
        
        informationBaseView(with: TextConstants.subTitle)
          .font(.pretendard(size: 14, weight: .medium))
          .foregroundColor(ColorConstants.gray2)
      }
      .padding(.vertical, 24)
      
      VStack(alignment: .leading, spacing: 4) {
        WithViewStore(store, observe: { $0 }) { viewStore in
          CheckButton(isAccentColor: viewStore.isAgreeAll) {
            viewStore.send(.didTapAll)
          } content: {
            Text(TextConstants.allAgreeText)
              .font(.pretendard(size: 18, weight: .bold))
          }
        }
        
        CheckButton(isAccentColor: false, isHidden: true, action: { }) {
          Text(TextConstants.allAgreeDetailText)
            .font(.pretendard(size: 14, weight: .medium))
            .foregroundColor(ColorConstants.gray2)
        }
      }
      
      
      Rectangle()
        .fill(Color.gray.opacity(0.3))
        .frame(height: 1)
        .padding(.vertical, 16)
      
      VStack(spacing: 12) {
        WithViewStore(store, observe: { $0 }) { viewStore in
          PrivacyCheckView(
            title: TextConstants.privacyText,
            isAccentColor: viewStore.isAgreePrivacy
          ) {
            viewStore.send(.didTapAgreePrivacy)
          } viewAction: {
            self.openURL(to: TextConstants.privacyURLString)
          }
        }
        
        WithViewStore(store, observe: { $0 }) { viewStore in
          PrivacyCheckView(
            title: TextConstants.termsText,
            isAccentColor: viewStore.isAgreeTerms
          ) {
            viewStore.send(.didTapAgreeTerms)
          } viewAction: {
            self.openURL(to: TextConstants.termURLString)
          }
        }
      }
      
      Spacer()
      
      WithViewStore(store, observe: { $0 }) { viewStore in
        Button {
          viewStore.send(.didTapConfirm)
        } label: {
          HStack {
            Spacer()
            
            Text(TextConstants.confirmText)
            
            Spacer()
          }
        }
        .font(.system(size: 18, weight: .bold))
        .foregroundColor(
          viewStore.isAgreeAll ? .black : ColorConstants.gray4
        )
        .disabled(viewStore.isAgreeAll == false)
        .padding(.vertical)
        .background(
          viewStore.isAgreeAll ? ColorConstants.primary : ColorConstants.gray5
        )
        .cornerRadius(8)
        .padding(.bottom, 24)
      }
    }
    .padding()
    .background(Color.white)
    .cornerRadius(20, corner: .topLeft)
    .cornerRadius(20, corner: .topRight)
    .edgesIgnoringSafeArea(.bottom)
  }
}

struct PrivacyCheckView: View {
  let title: String
  let isAccentColor: Bool
  let action: () -> Void
  let viewAction: () -> Void
  
  init(
    title: String,
    isAccentColor: Bool,
    action: @escaping () -> Void,
    viewAction: @escaping () -> Void
  ) {
    self.title = title
    self.isAccentColor = isAccentColor
    self.action = action
    self.viewAction = viewAction
  }
  
  var body: some View {
    CheckButton(isAccentColor: isAccentColor) {
      action()
    } content: {
      Text(TextConstants.necessaryText)
        .foregroundColor(.gray)
        .font(.pretendard(size: 12, weight: .medium))
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(ColorConstants.gray5)
        .cornerRadius(4)
      
      Text(title)
        .font(.pretendard(size: 16, weight: .medium))
      
      Spacer()
      
      Button(TextConstants.showText) {
        viewAction()
      }
      .font(.pretendard(size: 12, weight: .medium))
      .foregroundColor(.gray)
    }
  }
  
}

struct CheckButton<Content: View>: View {
  let isAccentColor: Bool
  let isHidden: Bool
  let action: () -> Void
  let content: () -> Content
  
  @ViewBuilder
  private func signUpCheckImage() -> some View {
    Image(systemName: "checkmark.circle")
      .resizable()
      .scaledToFit()
      .frame(width: 24, height: 24)
  }
  
  init(
    isAccentColor: Bool,
    isHidden: Bool = false,
    action: @escaping () -> Void,
    @ViewBuilder content: @escaping () -> Content
  ) {
    self.isAccentColor = isAccentColor
    self.isHidden = isHidden
    self.action = action
    self.content = content
  }
  
  var body: some View {
    HStack {
      Button {
        action()
      } label: {
        signUpCheckImage()
          .accentColor(
            isAccentColor ? ColorConstants.primary : ColorConstants.gray5
          )
      }
      .opacity(isHidden ? .zero : 1)
      .disabled(isHidden)
      
      content()
    }
  }
}

struct SignUpView_Previews: PreviewProvider {
  static var previews: some View {
    SignUpView(
      store: Store(
        initialState: SignUpCore.State(),
        reducer: { SignUpCore() }
      )
    )
  }
}

private extension SignUpView {
  enum TextConstants {
    static let title = "약관에 동의해주세요."
    static let subTitle = "필수항목에 대한 약관에 동의해주세요."
    static let allAgreeText = "전체 동의"
    static let allAgreeDetailText = "서비스 이용을 위해 아래 약관에 모두 동의합니다."
    static let privacyText = "개인 정보 처리방침"
    static let termsText = "서비스 이용약관"
    static let confirmText = "확인"
    
    static let privacyURLString = "https://scarlet-tsunami-ae6.notion.site/1108380d3ad64a2f987134e283220852?pvs=4"
    static let termURLString = "https://scarlet-tsunami-ae6.notion.site/9c400f50565d45508eaaae7cc6c312f8?pvs=4"
  }
}

private extension PrivacyCheckView {
  enum TextConstants {
    static let necessaryText = "필수"
    static let showText = "보기"
  }
}
