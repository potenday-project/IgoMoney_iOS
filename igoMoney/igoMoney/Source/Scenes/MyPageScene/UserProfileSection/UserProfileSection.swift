//
//  UserProfileSection.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

struct UserProfileSection: View {
  var body: some View {
    HStack(spacing: 8) {
      Image("default_profile")
      
      VStack(alignment: .leading) {
        Text("오마이머니")
          .foregroundColor(ColorConstants.primary)
        + Text("님")
        
        Text("현재 챌린지 진행 중!")
      }
      .font(.pretendard(size: 18, weight: .semiBold))
      
      Spacer()
      
      Image(systemName: "chevron.right")
        .foregroundColor(ColorConstants.gray4)
    }
    .padding(16)
    .background(Color.white)
    .cornerRadius(8)
    .shadow(
      color: ColorConstants.gray3.opacity(0.2),
      radius: 4,
      y: 2
    )
  }
}

#Preview {
  UserProfileSection()
    .previewLayout(.sizeThatFits)
}
