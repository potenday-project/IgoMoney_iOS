//
//  EnterChallengeInformationView.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

import ComposableArchitecture

struct ChallengeInformationCardView: View {
  let store: StoreOf<EnterChallengeInformationCore>
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      VStack(alignment: .leading, spacing: 8) {
        HStack {
          VStack(alignment: .leading, spacing: 4) {
            Text("\(viewStore.leaderName ?? "")님과 챌린지")
              .font(.pretendard(size: 14, weight: .bold))
              .foregroundColor(ColorConstants.gray2)
            
            Text(viewStore.challenge.title)
              .font(.pretendard(size: 18, weight: .bold))
              .lineLimit(1)
            
            HStack {
              Text(viewStore.challenge.targetAmount.description)
                .padding(.horizontal, 4)
                .font(.pretendard(size: 12, weight: .medium))
                .background(Color(viewStore.challenge.targetAmount.colorName))
                .cornerRadius(4)
              
              Text("⏰ 내일 부터 시작")
                .padding(.horizontal, 4)
                .font(.pretendard(size: 12, weight: .medium))
                .background(ColorConstants.primary7)
                .cornerRadius(4)
            }
          }
          
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
        
        Text(viewStore.challenge.content)
          .font(.pretendard(size: 14, weight: .medium))
      }
    }
    .padding(16)
    .background(Color.white)
    .cornerRadius(10)
    .padding(24)
    .onAppear {
      store.send(.onAppear)
    }
  }
}
