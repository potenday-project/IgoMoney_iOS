//
//  UserBadgeCounterView.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

import ComposableArchitecture

struct UserBadgeCounterView: View {
  let store: StoreOf<UserBadgeCounterCore>
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      VStack {
        HStack {
          Text("승리 뱃지 개수")
            .font(.pretendard(size: 14, weight: .bold))
            .lineHeight(font: .pretendard(size: 14, weight: .bold), lineHeight: 20)
          
          Spacer()
          
          Text("총 \(viewStore.badgeCount)개")
            .font(.pretendard(size: 14, weight: .medium))
            .lineHeight(font: .pretendard(size: 14, weight: .medium), lineHeight: 20)
        }
        
        HStack {
          ForEach(1...4, id: \.self) { index in
            Image(index == 1 ? "icon_badge_fill" : "icon_badge_unfill")
              .frame(maxWidth: .infinity)
          }
        }
      }
    }
    .padding(.vertical, 16)
    .padding(.horizontal, 12)
    .background(Color.white)
    .cornerRadius(8)
    .shadow(color: ColorConstants.gray5, radius: 4, y: 2)
  }
}
