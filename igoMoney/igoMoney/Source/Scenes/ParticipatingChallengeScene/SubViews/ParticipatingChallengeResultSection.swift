//
//  DetailChallengeResultSection.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

import ComposableArchitecture

struct DetailChallengeResultSection: View {
  let store: StoreOf<ParticipatingChallengeResultSectionCore>
  var body: some View {
    VStack(spacing: 12) {
      DetailChallengeResultCard()
      
      Divider()
      
      DetailChallengeResultCard()
      
      Divider()
      
      Text("현재 아이고머니님이 더 절약하고 있어요")
    }
    .padding(16)
    .background(ColorConstants.primary8)
    .cornerRadius(10)
  }
}

struct DetailChallengeResultCard: View {
  var body: some View {
    VStack(spacing: 8) {
      HStack {
        Text("아이고머니님")
        
        Spacer()
        
        Text("누적 금액 \(1900)원")
      }
      
      GeometryReader { proxy in
        let size = proxy.frame(in: .local).size
        
        VStack(alignment: .leading) {
          Image("icon_bolt")
            .offset(x: size.width * 0.27)
          
          Capsule()
            .fill(ColorConstants.primary6)
            .frame(width: size.width, height: 8)
            .overlay(
              Capsule()
                .fill(ColorConstants.primary)
                .frame(width: size.width * 0.27, height: 8),
              alignment: .leading
            )
          
          HStack {
            Text("0원")
            
            Spacer()
            
            Text("10000원")
          }
        }
      }
    }
    .frame(height: 80)
  }
}
