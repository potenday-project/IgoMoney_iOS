//
//  ChallengeStatisticSection.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

enum ChallengeCounterType: Int, CaseIterable {
  case win
  case total
  
  var title: String {
    switch self {
    case .win:
      return "승리"
    case .total:
      return "누적"
    }
  }
}

struct ChallengeStatisticSection: View {
  @ViewBuilder
  private func ChallengeCountCell(title: String, count: Int) -> some View {
    VStack {
      Text("승리 챌린지 수")
        .font(.pretendard(size: 14, weight: .medium))
        .lineHeight(font: .pretendard(size: 14, weight: .medium), lineHeight: 20)
      
      Text("5")
        .font(.pretendard(size: 20, weight: .bold))
        .lineHeight(font: .pretendard(size: 20, weight: .bold), lineHeight: 27)
    }
    .frame(maxWidth: .infinity)
    .padding(.vertical, 12)
    .background(ColorConstants.primary8)
    .cornerRadius(8)
    .shadow(color: ColorConstants.gray5, radius: 4, y: 2)
  }
  
  var body: some View {
    VStack(spacing: 16) {
      HStack(spacing: 8) {
        ForEach(ChallengeCounterType.allCases, id: \.rawValue) { counter in
          ChallengeCountCell(title: counter.title, count: 5)
        }
      }
      
      VStack {
        HStack {
          Text("승리 뱃지 개수")
            .font(.pretendard(size: 14, weight: .bold))
            .lineHeight(font: .pretendard(size: 14, weight: .bold), lineHeight: 20)
          
          Spacer()
          
          Text("총 1개")
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
      .padding(.vertical, 16)
      .padding(.horizontal, 12)
      .background(Color.white)
      .cornerRadius(8)
      .shadow(color: ColorConstants.gray5, radius: 4, y: 2)
    }
  }
}

#Preview {
  ChallengeStatisticSection()
    .padding()
}
