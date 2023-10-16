//
//  ExploreChallengeScene.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

import ComposableArchitecture

struct ExploreChallengeScene: View {
  @State private var showBottomSheet: Bool = false
  @ViewBuilder
  private func FilterButton(
    isSelected: Bool,
    isMenu: Bool,
    title: String,
    action: @escaping () -> Void
  ) -> some View {
    Button {
      action()
    } label: {
      HStack {
        Text(title)
        
        if isMenu {
          Image(systemName: "chevron.down")
        }
      }
    }
    .buttonStyle(.plain)
    .padding(.horizontal, 12)
    .padding(.vertical, 8)
    .foregroundColor(isSelected ? .black : ColorConstants.gray2)
    .background(
      RoundedRectangle(cornerRadius: 4)
        .stroke(
          isSelected ? ColorConstants.primary : ColorConstants.gray5
        )
    )
  }
  
  var body: some View {
    ZStack {
      VStack {
        HStack(spacing: 8) {
          FilterButton(isSelected: true, isMenu: false, title: "전체") {
            print("Tapped All")
          }
          
          FilterButton(isSelected: false, isMenu: true, title: "챌린지 주제") {
            withAnimation {
              showBottomSheet = true
            }
          }
          
          FilterButton(isSelected: false, isMenu: true, title: "금액") {
            withAnimation {
              showBottomSheet = true
            }
          }
          
          Spacer()
        }
        
        Spacer()
      }
      
      if showBottomSheet {
        GeometryReader { proxy in
          IGOBottomSheetView(isOpen: $showBottomSheet, maxHeight: proxy.size.height * 0.65) {
            Text("Example")
          }
          .edgesIgnoringSafeArea(.all)
        }
      }
    }
  }
}

struct ExploreChallengeScene_Previews: PreviewProvider {
  static var previews: some View {
    ExploreChallengeScene()
  }
}
