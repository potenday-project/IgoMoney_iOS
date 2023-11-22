//
//  AuthSettingScene.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

import ComposableArchitecture

struct AuthSettingScene: View {
  @Environment(\.presentationMode) var presentationMode
  let store: StoreOf<AuthSettingCore>
  
  @ViewBuilder
  private func AuthSettingCell(title: String) -> some View {
    HStack {
      Text(title)
      
      Spacer()
      
      Image(systemName: "chevron.forward")
    }
    .font(.pretendard(size: 14, weight: .bold))
    .foregroundColor(ColorConstants.gray4)
    .padding(.vertical, 20)
  }
  
  var body: some View {
    ZStack {
      VStack {
        IGONavigationBar {
          Text("로그인 정보")
        } leftView: {
          Button {
            presentationMode.wrappedValue.dismiss()
          } label: {
            Image(systemName: "chevron.backward")
          }
        } rightView: {
          EmptyView()
        }
        .font(.pretendard(size: 20, weight: .bold))
        .buttonStyle(.plain)
        .padding(.vertical, 16)
        
        HStack {
          Text("SNS 연동")
          
          Spacer()
        }
        .font(.pretendard(size: 16, weight: .bold))
        .padding(.vertical, 16)
        
        WithViewStore(store, observe: { $0 }) { viewStore in
          AuthInformationCard(viewStore: viewStore)
            .onChange(of: viewStore.isPresentation) { newValue in
              if newValue == false {
                presentationMode.wrappedValue.dismiss()
              }
            }
        }
        
        Divider()
        
        Button {
          store.send(.showSignOut(true))
        } label: {
          AuthSettingCell(title: "로그아웃")
        }
        
        Button {
          store.send(.showWithdraw(true))
        } label: {
          AuthSettingCell(title: "회원 탈퇴")
        }
        
        Spacer()
      }
      .padding(.horizontal, 24)
      
      GeometryReader { proxy in
        WithViewStore(store, observe: { $0 }) { viewStore in
          if viewStore.showSignOutSheet {
            IGOBottomSheetView(
              isOpen: viewStore.binding(
                get: \.showSignOutSheet,
                send: AuthSettingCore.Action.showSignOut
              ),
              maxHeight: proxy.size.height * 0.3
            ) {
              SignOutBottomSheetView(viewStore: viewStore)
            }
          }
          
          if viewStore.showWithdrawSheet {
            IGOBottomSheetView(
              isOpen: viewStore.binding(
                get: \.showWithdrawSheet,
                send: AuthSettingCore.Action.showWithdraw
              ),
              maxHeight: proxy.size.height * 0.3
            ) {
              WithdrawBottomSheetView(viewStore: viewStore)
            }
          }
        }
      }
      .transition(.move(edge: .bottom))
    }
    .edgesIgnoringSafeArea(.bottom)
    .navigationBarHidden(true)
    .onAppear {
      store.send(.onAppear)
    }
  }
}

struct SignOutBottomSheetView: View {
  let viewStore: ViewStoreOf<AuthSettingCore>
  
  var body: some View {
    VStack(spacing: 24) {
      VStack(spacing: 16) {
        Text("로그아웃 하시겠습니까?")
          .font(.pretendard(size: 22, weight: .bold))
        
        Text("로그아웃 후 홈화면으로 돌아가게 됩니다.")
          .font(.pretendard(size: 16, weight: .medium))
      }
      
      HStack(spacing: 8) {
        Button {
          viewStore.send(.showSignOut(false))
        } label: {
          Text("아니요")
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(ColorConstants.gray5)
        .cornerRadius(8)
        
        Button {
          viewStore.send(.signOut)
        } label: {
          Text("네")
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(ColorConstants.primary)
        .cornerRadius(8)
      }
      .buttonStyle(.plain)
      .font(.pretendard(size: 18, weight: .medium))
    }
    .padding(.horizontal, 24)
  }
}

struct WithdrawBottomSheetView: View {
  let viewStore: ViewStoreOf<AuthSettingCore>
  
  var body: some View {
    VStack(spacing: 24) {
      VStack(spacing: 16) {
        Text("정말 탈퇴하시겠습니까?")
          .font(.pretendard(size: 22, weight: .bold))
        
        Text("회원 탈퇴 후 30일간 재가입이 불가하며,\n혜택은 사라지게 되며 다시 제공되지 않습니다.")
          .multilineTextAlignment(.center)
          .font(.pretendard(size: 16, weight: .medium))
          .foregroundColor(ColorConstants.gray3)
          .lineHeight(font: .pretendard(size: 16, weight: .medium), lineHeight: 23)
      }
      
      HStack(spacing: 8) {
        Button {
          viewStore.send(.showWithdraw(false))
        } label: {
          Text("아니요")
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(ColorConstants.gray5)
        .cornerRadius(8)
        
        Button {
          viewStore.send(.withdraw)
        } label: {
          Text("네")
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(ColorConstants.primary)
        .cornerRadius(8)
      }
      .buttonStyle(.plain)
      .font(.pretendard(size: 18, weight: .medium))
    }
    .padding(.horizontal, 24)
  }
}

struct AuthInformationCard: View {
  let viewStore: ViewStoreOf<AuthSettingCore>
  
  var body: some View {
    if let provider = viewStore.token?.provider,
       let userEmail = viewStore.userEmail {
      HStack {
        VStack(alignment: .leading, spacing: 4) {
          Text(provider.description)
            .foregroundColor(ColorConstants.gray)
          
          Text(userEmail)
            .foregroundColor(ColorConstants.gray2)
        }
        .font(.pretendard(size: 14, weight: .medium))
        
        Spacer()
        
        Image(provider.iconName)
          .padding(8)
          .background(
            Circle()
              .fill(provider == .kakao ? Color(provider.colorName) : ColorConstants.gray4)
          )
      }
    } else {
      HStack {
        Text("계정 정보를 불러오는데 오류가 발생하였습니다.")
        
        Spacer()
      }
      .font(.pretendard(size: 14, weight: .medium))
      .foregroundColor(ColorConstants.gray2)
    }
  }
}

#Preview {
  AuthSettingScene(
    store: Store(
      initialState: AuthSettingCore.State(),
      reducer: { AuthSettingCore() }
    )
  )
}
