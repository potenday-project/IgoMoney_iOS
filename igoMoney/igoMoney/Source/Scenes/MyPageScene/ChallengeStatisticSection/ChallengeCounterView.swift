//
//  ChallengeCounterView.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

import ComposableArchitecture

struct ChallengeCounterView: View {
  let store: StoreOf<ChallengeCounterCore>
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      VStack {
        Text("\(viewStore.challengeType.title) 챌린지 수")
          .font(.pretendard(size: 14, weight: .medium))
          .lineHeight(font: .pretendard(size: 14, weight: .medium), lineHeight: 20)
        
        Text("\(viewStore.challengeCount)")
          .font(.pretendard(size: 20, weight: .bold))
          .lineHeight(font: .pretendard(size: 20, weight: .bold), lineHeight: 27)
      }
    }
    .frame(maxWidth: .infinity)
    .padding(.vertical, 12)
    .background(ColorConstants.primary8)
    .cornerRadius(8)
    .shadow(color: ColorConstants.gray5, radius: 4, y: 2)
    .onAppear {
      store.send(.onAppear)
    }
  }
}
