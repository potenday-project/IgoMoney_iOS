//
//  InformationScene.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

import ComposableArchitecture

enum Information: Int, CaseIterable {
  case agree
  case privacy
  case openSource
  
  var title: String {
    switch self {
    case .agree:
      return "이용약관"
    case .privacy:
      return "개인정보 정책"
    case .openSource:
      return "오픈소스"
    }
  }
}

struct InformationScene: View {
  @Environment(\.openURL) var openURL
  @Environment(\.presentationMode) var presentationMode
  
  var body: some View {
    VStack(spacing: .zero) {
      IGONavigationBar {
        Text("정보")
      } leftView: {
        Button {
          presentationMode.wrappedValue.dismiss()
        } label: {
          Image(systemName: "chevron.left")
        }
        .buttonStyle(.plain)
        .foregroundColor(.black)
      } rightView: {
        EmptyView()
      }
      .font(.pretendard(size: 20, weight: .bold))
      .padding(.horizontal, 24)
      .padding(.bottom, 24)
      .padding(.top, 16)
      
      List(Information.allCases, id: \.rawValue) { information in
        Button {
          switch information {
          case .agree:
            if let url = URL(string: SystemConfigConstants.termURLString) {
              openURL(url)
            }
            
          case .privacy:
            if let url = URL(string: SystemConfigConstants.privacyURLString) {
              openURL(url)
            }
            
          case .openSource:
            if let url = URL(string: UIApplication.openSettingsURLString) {
              openURL(url)
            }
          }
        } label: {
          Text(information.title)
            .font(.pretendard(size: 16, weight: .semiBold))
            .padding(16)
        }
        .buttonStyle(.plain)
      }
      .listStyle(.plain)
      .listRowInsets(EdgeInsets(top: .zero, leading: 24, bottom: .zero, trailing: 24))
    }
    .navigationTitle("")
    .navigationBarHidden(true)
  }
}

#Preview {
  InformationScene()
}
