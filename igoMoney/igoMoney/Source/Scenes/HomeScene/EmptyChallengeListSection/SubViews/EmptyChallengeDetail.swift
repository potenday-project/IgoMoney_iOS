//
//  EmptyChallengeDetail.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

import ComposableArchitecture

struct EmptyChallengeDetail: View {
  let store: StoreOf<EnterChallengeInformationCore>
  
  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      // 챌린지 타이틀
      WithViewStore(store, observe: { $0.challenge.title }) { viewStore in
        Text(viewStore.state)
          .multilineTextAlignment(.leading)
          .lineLimit(2)
          .font(.pretendard(size: 16, weight: .semiBold))
          .lineHeight(font: .pretendard(size: 16, weight: .semiBold), lineHeight: 23)
      }
      
      Spacer()
      
      // 챌린지 생성자 닉네임
      WithViewStore(store, observe: { $0 }) { viewStore in
        Text(viewStore.leader?.nickName ?? "")
          .font(.system(size: 12, weight: .medium))
      }
      
      VStack(alignment: .leading, spacing: 2) {
        // 챌린지 머니
        WithViewStore(store, observe: { $0.challenge.targetAmount }) { viewStore in
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
        
        URLImage(
          store: self.store.scope(
            state: \.urlImageState,
            action: EnterChallengeInformationCore.Action.urlImageAction
          )
        )
        .scaledToFill()
        .frame(width: 50, height: 50)
        .clipShape(Circle())
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
    .frame(height: 190)
    .onAppear {
      store.send(.onAppear)
    }
  }
}

#Preview {
  EmptyChallengeDetail(
    store: Store(
      initialState: EnterChallengeInformationCore.State(challenge: .default),
      reducer: { EnterChallengeInformationCore() }
    )
  )
}
