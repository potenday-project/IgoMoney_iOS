//
//  EnterChallengeNoticeView.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

struct ChallengeNoticeView: View {
  struct Notice: Hashable {
    let index: Int
    let description: String
    private var icon: String? = nil
    
    var iconName: String {
      if let icon = icon {
        return icon
      } else {
        return "\(index).circle"
      }
    }
    
    static let defaultMethodNotice: [Notice] = [
      .init(index: 1, description: "참가 후 다음날부터 챌린지가 일주일동안 진행되요"),
      .init(index: 2, description: "내가 지출한 금액과 사진을 매일 인증하세요."),
      .init(index: 3, description: "목표 금액을 달성하면 승리합니다."),
      .init(index: 4, description: "챌린지에서 이기면 승리 뱃지가 지급됩니다."),
    ]
    
    static let defaultDuringNotice: [Notice] = [
      .init(index: 1, description: "하루에 최소 1번 인증샷과 지출 금액을 인증해야 합니다.", icon: "checkmark.circle"),
      .init(index: 2, description: "인증샷과 지출 금액은 상대방에게 공개됩니다.", icon: "checkmark.circle"),
      .init(index: 3, description: "챌린지를 포기할 경우 상대방이 승리하게 됩니다.", icon: "checkmark.circle"),
      .init(index: 4, description: "모두 목표 금액 달성 시, 적게 지출 한쪽이 승리합니다.", icon: "checkmark.circle"),
    ]
  }
  
  @ViewBuilder
  private func noticeSectionView(notices: [Notice]) -> some View {
    VStack(alignment: .leading, spacing: 8) {
      ForEach(notices, id: \.index) { notice in
        HStack {
          Image(systemName: notice.iconName)
          
          Text(notice.description)
          
          Spacer()
        }
        .frame(maxWidth: .infinity)
      }
    }
    .font(.pretendard(size: 14, weight: .medium))
    .padding(16)
    .background(Color.white)
    .cornerRadius(10)
    .shadow(color: ColorConstants.gray2.opacity(0.2), radius: 8, y: 2)
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 24) {
      VStack(alignment: .leading, spacing: 16) {
        Text("📣 챌린지 진행 방법")
          .font(.pretendard(size: 18, weight: .semiBold))
        
        noticeSectionView(notices: Notice.defaultMethodNotice)
      }
      
      VStack(alignment: .leading, spacing: 16) {
        Text("📌 챌린지 진행 시 꼭 알아주세요!")
          .font(.pretendard(size: 18, weight: .semiBold))
        
        noticeSectionView(notices: Notice.defaultDuringNotice)
      }
    }
  }
}
