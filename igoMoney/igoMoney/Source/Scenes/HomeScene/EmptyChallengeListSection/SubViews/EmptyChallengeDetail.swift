//
//  EmptyChallengeDetail.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

import ComposableArchitecture
import Inject

struct EmptyChallengeDetail: View {
  @ObservedObject private var inject = Inject.observer
  let store: StoreOf<ChallengeInformationCore>
  
  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      // 챌린지 타이틀
      WithViewStore(store, observe: { $0.challenge.title }) { viewStore in
        Text(viewStore.state)
          .multilineTextAlignment(.leading)
          .font(.pretendard(size: 16, weight: .semiBold))
          .lineHeight(font: .pretendard(size: 16, weight: .semiBold), lineHeight: 23)
      }
      
      // 챌린지 생성자 닉네임
      WithViewStore(store, observe: { $0 }) { viewStore in
        Text(viewStore.leader?.nickName ?? "")
          .font(.system(size: 12, weight: .medium))
      }
      
      VStack(alignment: .leading, spacing: 2) {
        // 챌린지 머니
        HStack(spacing: 2) {
          WithViewStore(store, observe: { $0.challenge.targetAmount }) { viewStore in
            Text(viewStore.description)
              .padding(.horizontal, 2)
              .background(ColorConstants.yellow)
              .cornerRadius(4)
          }
          
          WithViewStore(store, observe: { $0.challenge.category }) { category in
            Text("#" + (category.state?.description ?? ""))
              .padding(.horizontal, 2)
              .background(ColorConstants.orange)
              .cornerRadius(4)
          }
        }
        
        WithViewStore(store, observe: { $0.challenge }) { challenge in
          Text("⏰" + (challenge.startDate?.toString(with: "MM월 dd일 시작") ?? ""))
            .padding(.horizontal, 2)
            .padding(.vertical, 1)
            .background(ColorConstants.primary7)
            .cornerRadius(4)
        }
      }
      .font(.system(size: 12, weight: .medium))
      
      HStack {
        Spacer()
        
        URLImage(
          store: self.store.scope(
            state: \.urlImageState,
            action: ChallengeInformationCore.Action.urlImageAction
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
    .frame(maxHeight: 200)
    .onAppear {
      store.send(.onAppear)
    }
    .enableInjection()
  }
}

#Preview {
  EmptyChallengeDetail(
    store: Store(
      initialState: ChallengeInformationCore.State(challenge: .default),
      reducer: { ChallengeInformationCore() }
    )
  )
}
