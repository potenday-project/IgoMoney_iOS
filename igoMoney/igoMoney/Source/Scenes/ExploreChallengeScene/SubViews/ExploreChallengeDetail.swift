//
//  ExploreChallengeDetail.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

import ComposableArchitecture

struct ExploreChallengeCellView: View {
  let challenge: Challenge
  
  var body: some View {
    // TODO: - Challenge Detail 데이터 불러오기
    
    HStack {
      VStack(alignment: .leading) {
        Text("오마이머니님")
          .font(.pretendard(size: 12, weight: .medium))
        
        Text(challenge.title)
          .font(.pretendard(size: 16, weight: .bold))
          .padding(.bottom, 2)
          .lineLimit(1)
        
        HStack {
          Text(challenge.targetAmount.description)
            .padding(.horizontal, 4)
            .background(ColorConstants.yellow)
            .cornerRadius(4)
          
          Text("#" + (challenge.category?.description ?? ""))
            .padding(.horizontal, 4)
            .background(ColorConstants.red)
            .cornerRadius(4)
          
          Text(challenge.startDate?.toString(with: "⏰ MM월 dd일 시작") ?? "")
            .padding(.horizontal, 4)
            .background(ColorConstants.primary7)
            .cornerRadius(4)
        }
        .font(.pretendard(size: 12, weight: .medium))
      }
      
      Image("default_profile")
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
  }
}
