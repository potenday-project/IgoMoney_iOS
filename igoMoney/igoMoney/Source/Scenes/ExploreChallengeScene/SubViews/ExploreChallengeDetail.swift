//
//  ExploreChallengeDetail.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

import ComposableArchitecture

struct ExploreChallengeCellView: View {
  let store: StoreOf<ChallengeInformationCore>
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      HStack {
        VStack(alignment: .leading) {
          Text((viewStore.leader?.nickName ?? "") + "님")
            .font(.pretendard(size: 12, weight: .medium))
          
          Text(viewStore.challenge.title)
            .font(.pretendard(size: 16, weight: .bold))
            .padding(.bottom, 2)
            .lineLimit(1)
          
          HStack {
            Text(viewStore.challenge.targetAmount.description)
              .padding(.horizontal, 4)
              .background(ColorConstants.yellow)
              .cornerRadius(4)
            
            Text("#" + (viewStore.challenge.category?.description ?? ""))
              .padding(.horizontal, 4)
              .background(ColorConstants.red)
              .cornerRadius(4)
            
            Text(viewStore.challenge.startDate?.toString(with: "⏰ MM월 dd일 시작") ?? "")
              .padding(.horizontal, 4)
              .background(ColorConstants.primary7)
              .cornerRadius(4)
          }
          .font(.pretendard(size: 12, weight: .medium))
        }
        
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
    .padding(.horizontal, 16)
    .padding(.vertical, 12)
    .background(Color.white)
    .cornerRadius(10)
    .shadow(
      color: ColorConstants.gray4.opacity(0.2),
      radius: 8,
      y: 2
    )
    .padding(.horizontal, 24)
    .onAppear {
      store.send(.onAppear)
    }
  }
}
