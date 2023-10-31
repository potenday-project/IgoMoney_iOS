//
//  CertifiedArticleSection.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

import ComposableArchitecture

struct CertifiedArticleSection: View {
  @ViewBuilder
  private func ChallengeClassificationButton(
    title: String,
    isSelected: Bool,
    action: @escaping () -> Void
  ) -> some View {
    Button {
      action()
    } label: {
      Text(title)
        .padding(.vertical, 8)
    }
    .buttonStyle(.plain)
    .foregroundColor(isSelected ? Color.black : ColorConstants.gray3)
    .frame(maxWidth: .infinity)
    .overlay(
      Rectangle()
        .frame(height: 1.5)
        .foregroundColor(isSelected ? Color.black : ColorConstants.gray3)
      , alignment: .bottom
    )
  }
  
  var body: some View {
    ZStack {
      Color.white.edgesIgnoringSafeArea(.all)
      
      VStack(spacing: 24) {
        HStack(spacing: 16) {
          ChallengeClassificationButton(
            title: "나의 챌린지",
            isSelected: true
          ) {
            print("Tapped 나의 챌린지")
          }
          
          ChallengeClassificationButton(
            title: "상대방 챌린지",
            isSelected: false
          ) {
            print("Tapped 상대방 챌린지")
          }
        }
        .padding(.top, 20)
        .font(.pretendard(size: 16, weight: .bold))
        
        Spacer()
      }
      .padding(.horizontal, 24)
    }
    .cornerRadius(20, corner: .topLeft)
    .cornerRadius(20, corner: .topRight)
  }
}

#Preview {
  CertifiedArticleSection()
    .padding()
    .background(ColorConstants.gray4)
}
