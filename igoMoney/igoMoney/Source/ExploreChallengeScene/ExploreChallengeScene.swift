//
//  ExploreChallengeScene.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

import ComposableArchitecture

struct ExploreChallengeScene: View {
  @State private var showBottomSheet: Bool = true
  private var challenges = Array(repeating: Challenge.default, count: 50)
  
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
      VStack(spacing: 24) {
        IGONavigationBar {
          Text("챌린지 둘러보기")
        } leftView: {
          Button {
            
          } label: {
            Image(systemName: "chevron.left")
          }
        } rightView: {
          Button {
            
          } label: {
            Image(systemName: "plus.circle")
          }
        }
        .font(.pretendard(size: 20, weight: .bold))
        .padding(.vertical, 16)
        .accentColor(.black)
        .padding(.horizontal, 24)
        
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
        .padding(.horizontal, 24)
        
        ScrollView(.vertical, showsIndicators: false) {
          VStack(spacing: 12) {
            ForEach(challenges, id: \.id) { challenge in
              ExploreChallengeCellView(challenge: challenge)
              .padding(.horizontal, 24)
            }
          }
          .padding(4)
        }
      }
      
      if showBottomSheet {
        GeometryReader { proxy in
          IGOBottomSheetView(isOpen: $showBottomSheet, maxHeight: proxy.size.height * 0.65) {
            ExploreChallengeFilterView()
          }
          .edgesIgnoringSafeArea(.all)
        }
      }
    }
  }
}

struct ExploreChallengeCellView: View {
  let challenge: Challenge
  var body: some View {
    HStack(spacing: 12) {
      VStack(alignment: .leading, spacing: 2) {
        // TODO: - Challenge User Information 가져오기
        Text("머니레터님")
          .font(.pretendard(size: 12, weight: .medium))
          .foregroundColor(ColorConstants.gray3)
        
        Text(challenge.title)
          .lineLimit(1)
          .font(.pretendard(size: 16, weight: .bold))
        
        HStack {
          Text(challenge.targetAmount.description)
            .padding(.horizontal, 4)
            .background(ColorConstants.yellow)
            .cornerRadius(4)
          
          Text("#" + (challenge.category?.description ?? ""))
            .padding(.horizontal, 4)
            .background(ColorConstants.red)
            .cornerRadius(4)
          
          Text(challenge.startDate?.toString(with: "⏰ MM월dd일 시작") ?? "")
            .padding(.horizontal, 4)
            .background(ColorConstants.primary7)
            .cornerRadius(4)
        }
        .font(.pretendard(size: 12, weight: .medium))
      }
      
      Image("default_profile")
    }
    .padding(16)
    .background(Color.white)
    .cornerRadius(10)
    .shadow(color: ColorConstants.gray2.opacity(0.2), radius: 4, y: 2)
  }
}

struct ExploreChallengeFilterView: View {
  var body: some View {
    VStack(alignment: .leading, spacing: 24) {
      Text("챌린지 주제")
        .font(.pretendard(size: 18, weight: .bold))
      
      LazyVGrid(columns: Array(repeating: .init(), count: 3)) {
        ForEach(ChallengeCategory.allCases, id: \.rawValue) { category in
          Button {
            
          } label: {
            ChallengeCategoryView(
              isSelection: category.rawValue == 1,
              category: category
            )
          }
        }
      }
      
      Text("챌린지 금액")
        .font(.pretendard(size: 18, weight: .bold))
      
      HStack {
        ForEach(TargetMoneyAmount.allCases, id: \.money) { amount in
          ChallengeTargetMoneyView(
            isSelection: amount.money == 10000,
            amount: amount
          )
        }
      }
      
      Spacer()
      
      Button("완료") {
        
      }
      .font(.pretendard(size: 18, weight: .medium))
      .frame(maxWidth: .infinity)
      .buttonStyle(.plain)
      .padding()
      .background(ColorConstants.primary)
      .cornerRadius(8)
      .padding(.bottom, 32)
    }
    .padding(.horizontal, 24)
  }
}

struct ExploreChallengeScene_Previews: PreviewProvider {
  static var previews: some View {
    ExploreChallengeScene()
  }
}
