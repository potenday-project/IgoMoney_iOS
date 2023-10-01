//
//  ExploreChallengeDetail.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

import ComposableArchitecture

struct ExploreChallengeDetail: View {
  let challenge: ChallengeInformation
  
  var body: some View {
    HStack(alignment: .center) {
      if let path = challenge.user.profileImagePath {
        Image(path)
          .frame(width: 65, height: 65)
      } else {
        Image("default_profile")
          .frame(width: 65, height: 65)
      }
      
      HStack(alignment: .firstTextBaseline) {
        VStack(alignment: .leading, spacing: .zero) {
          Text(challenge.user.nickName ?? "" + "님")
            .font(.pretendard(size: 12, weight: .medium))
          
          Text(challenge.title)
            .font(.pretendard(size: 16, weight: .bold))
            .padding(.bottom, 2)
          
          HStack {
            Text(challenge.targetAmount.description)
              .padding(.horizontal, 4)
              .background(Color(challenge.targetAmount.colorName))
              .cornerRadius(4)
            
            Text("⏰ 내일부터 시작")
              .padding(.horizontal, 4)
              .background(ColorConstants.primary7)
              .cornerRadius(4)
          }
          .font(.pretendard(size: 12, weight: .medium))
        }
        
        Spacer()
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
  }
}

struct ExploreChallengeDetail_Previews: PreviewProvider {
  static var previews: some View {
    ExploreChallengeDetail(challenge: .default.first!)
  }
}
