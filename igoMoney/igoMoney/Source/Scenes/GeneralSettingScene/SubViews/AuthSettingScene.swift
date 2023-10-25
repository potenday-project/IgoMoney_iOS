//
//  AuthSettingScene.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

import ComposableArchitecture

struct AuthSettingScene: View {
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
      
      
      HStack {
        VStack {
          Text(Provider.kakao.description)
        }
        
        Spacer()
        
        Image("icon_kakao")
          .padding(8)
          .background(
            Circle()
              .fill(Color("kakao_color"))
          )
      }
      
      
      Divider()
      
      Button {
        
      } label: {
        AuthSettingCell(title: "로그아웃")
      }
      
      Button {
        
      } label: {
        AuthSettingCell(title: "회원 탈퇴")
      }
      
      Spacer()
    }
    .padding(.horizontal, 24)
  }
}

#Preview {
  AuthSettingScene()
}
