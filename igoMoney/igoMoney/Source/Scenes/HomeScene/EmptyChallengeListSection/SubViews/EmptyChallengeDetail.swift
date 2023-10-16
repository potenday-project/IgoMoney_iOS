//
//  EmptyChallengeDetail.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

import ComposableArchitecture

struct EmptyChallengeDetail: View {
  let store: StoreOf<ChallengeDetailCore>
  
  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      // 챌린지 타이틀
      WithViewStore(store, observe: { $0.title }) { viewStore in
        Text(viewStore.state)
          .multilineTextAlignment(.leading)
          .lineLimit(2)
          .font(.pretendard(size: 16, weight: .semiBold))
          .lineHeight(font: .pretendard(size: 16, weight: .semiBold), lineHeight: 23)
      }
      
      // 챌린지 생성자 닉네임
      WithViewStore(store, observe: { $0.leader }) { viewStore in
        Text(viewStore.nickName ?? "")
          .font(.system(size: 12, weight: .medium))
      }
      
      VStack(alignment: .leading, spacing: 2) {
        // 챌린지 머니
        WithViewStore(store, observe: { $0.targetAmount }) { viewStore in
          Text(viewStore.description)
            .padding(.horizontal, 2)
            .background(Color(viewStore.colorName))
            .cornerRadius(4)
        }
        
        Text("⏰ 내일부터 시작")
          .padding(.horizontal, 2)
          .background(ColorConstants.primary7)
          .cornerRadius(4)
      }
      .font(.system(size: 12, weight: .medium))
      
      HStack {
        Spacer()
        
        // 사용자 이미지
        WithViewStore(store, observe: { $0.leader.profileImagePath }) { viewStore in
          if let path = viewStore.state {
            // 사용자 프로필 이미지로 변경하기
            Image("default_profile")
              .resizable()
              .scaledToFit()
              .frame(width: 50)
          } else {
            Image("default_profile")
              .resizable()
              .scaledToFit()
              .frame(width: 50)
          }
        }
      }
    }
    .padding(16)
    .background(
      RoundedRectangle(cornerRadius: 10)
        .fill(.white)
        .shadow(
          color: ColorConstants.gray2.opacity(0.15),
          radius: 4,
          y: 2
        )
    )
    .frame(minHeight: 190)
    .onAppear {
      store.send(._onAppear)
    }
  }
}

#Preview {
  EmptyChallengeDetail(
    store: Store(
      initialState: ChallengeDetailCore.State(
        challenge: .default
      ), reducer: { ChallengeDetailCore() }
    )
  )
}