//
//  MyPageScene.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

struct MyPageScene: View {
  var body: some View {
    VStack {
      IGONavigationBar {
        EmptyView()
      } leftView: {
        Text("마이페이지")
          .font(.pretendard(size: 20, weight: .bold))
      } rightView: {
        Button {
          // TODO: - 설정 이동 메서드 구현
        } label: {
          Image("icon_gear")
        }
      }
      
      // TODO: - 사용자 상세 정보 화면 구현
      Spacer()
    }
    .padding(.horizontal, 24)
    .padding(.vertical, 16)
  }
}

#Preview {
  MyPageScene()
}
