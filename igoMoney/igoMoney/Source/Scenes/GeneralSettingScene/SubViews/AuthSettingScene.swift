//
//  AuthSettingScene.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

import ComposableArchitecture

struct AuthSettingScene: View {
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
    VStack {
      IGONavigationBar {
        Text("로그인 정보")
      } leftView: {
        Button {
          
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
      }
      
      Divider()
      
      Button {
        store.send(.signOut)
      } label: {
        AuthSettingCell(title: "로그아웃")
      }
      
      Button {
        store.send(.withdraw)
      } label: {
        AuthSettingCell(title: "회원 탈퇴")
      }
      
      Spacer()
    }
    .navigationBarHidden(true)
    .padding(.horizontal, 24)
    .onAppear {
      store.send(.onAppear)
    }
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
