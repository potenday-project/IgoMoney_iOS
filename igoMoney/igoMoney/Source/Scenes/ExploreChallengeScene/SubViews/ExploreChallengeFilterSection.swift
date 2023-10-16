//
//  ExploreChallengeFilterSection.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

import ComposableArchitecture

struct ExploreChallengeFilterSection: View {
  let viewStore: ViewStoreOf<ExploreChallengeCore>
  
  var body: some View {
    HStack(spacing: 8) {
      ForEach(TargetMoneyAmount.allCases, id: \.self) { money in
        HStack(alignment: .center) {
          Spacer()
          
          Text(money.title)
            .lineLimit(1)
            .multilineTextAlignment(.center)
            .font(.pretendard(size: 14, weight: .medium))
            .minimumScaleFactor(0.8)
          
          Spacer()
        }
        .padding(.vertical, 8)
        .foregroundColor(money == viewStore.selectedMoney ? .black : ColorConstants.gray3)
        .background(
          money == viewStore.selectedMoney ?
          ColorConstants.primary : ColorConstants.gray5
        )
        .cornerRadius(4)
        .onTapGesture {
          viewStore.send(.selectMoney(money))
        }
      }
    }
  }
}
